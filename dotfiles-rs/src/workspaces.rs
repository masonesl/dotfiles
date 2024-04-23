use hyprland::{
    self,
    shared::HyprData as _
};
use serde_json::{
    value as json_value,
    map   as json_map,
    json,
};

#[derive(Debug)]
struct NamedWorkspace<'a> {
    display_name: &'a str,
    is_active: bool,
}

impl<'a> NamedWorkspace<'a> {
    fn new(display_name: &'a str) -> Self {
        return Self {
            display_name,
            is_active: false,
        };
    }

    fn get_json(&self) -> json_value::Value {
        json!({
            "display": self.display_name,
            "active":  self.is_active
        })
    }
}

pub mod monitor {
    use hyprland::dispatch;
    use indexmap::{
        map::IndexMap,
        set::IndexSet,
    };

    use super::*;
    use crate::config::workspaces::{
        NAMED_ALLOC,
        UNNAMED_ALLOC
    };

    const ALL_ALLOC: usize = NAMED_ALLOC + UNNAMED_ALLOC;

    pub struct MonitorContainer<'a> {
        unique_name:
            &'a str,
        named_workspaces:
            IndexMap<usize, NamedWorkspace<'a>>,
        unnamed_workspaces:
            IndexSet<usize>,
    }

    impl<'a> MonitorContainer<'a> {
        #[allow(unused)]
        pub fn new(unique_name: &'a str) -> Self {
            return Self {
                unique_name,
                named_workspaces: 
                    IndexMap::<usize, NamedWorkspace>::with_capacity(NAMED_ALLOC),
                unnamed_workspaces: 
                    IndexSet::<usize>::with_capacity(UNNAMED_ALLOC),
            };
        }

        pub fn add_named_workspace(&mut self, unique_id: usize, display_name: &'a str) {
            // TODO: handle result and option
            self.named_workspaces
                .insert_within_capacity(
                    unique_id,
                    NamedWorkspace::new(display_name)
                )
                .unwrap();
        }

        pub fn update(&mut self) {
            // set all workspaces to inactive
            self.named_workspaces
                .values_mut()
                .for_each(|named| named.is_active = false);
            self.unnamed_workspaces.clear();

            // TODO: handle result
            let workspaces = hyprland::data::Workspaces::get().unwrap();

            for workspace in workspaces {
                // ignore workspaces not on specified monitor
                if workspace.monitor != self.unique_name {
                    continue;
                }

                match self.named_workspaces
                    .get_mut(&(workspace.id as usize))
                {
                    Some(named) => named.is_active = true,
                    None        => {
                        // TODO: handle result
                        self.unnamed_workspaces
                            .insert_within_capacity(workspace.id as usize)
                            .unwrap();
                    }
                }
            }
        }

        pub fn goto_workspace(&mut self, workspace_id: usize) {
            use hyprland::dispatch;
            use hyprland::dispatch::*;

            self.update();

            let workspace_index = workspace_id - 1;

            let new_id = if workspace_index < NAMED_ALLOC {
                self.named_workspaces
                    .get_index(workspace_index)
                    .unwrap()
                    .0
            } else if workspace_index < ALL_ALLOC {
                self.unnamed_workspaces
                    .get_index(workspace_index - NAMED_ALLOC)
                    .unwrap()
            } else {
                todo!()
            };

            // TODO: handle result
            dispatch!(
                Workspace,
                WorkspaceIdentifierWithSpecial::Id(*new_id as i32)
            )
            .unwrap();
        }

        pub fn create_workspace(&mut self) {
            use hyprland::dispatch;
            use hyprland::dispatch::*;

            self.update();

            // move to a workspace one past the last
            // TODO: handle result
            dispatch!(
                Workspace,
                WorkspaceIdentifierWithSpecial::Id(
                    (NAMED_ALLOC + self.unnamed_workspaces.len() + 1) as i32
                )
            )
            .unwrap();
        }

        pub fn get_json(&mut self) -> String {
            self.update();

            let mut json_object = json_map::Map::with_capacity(ALL_ALLOC);

            for (id, workspace) in self.named_workspaces.iter() {
                json_object.insert(
                    id.to_string(),
                    workspace.get_json()
                );
            }

            for id in self.unnamed_workspaces.iter() {
                json_object.insert(
                    id.to_string(),
                    json!({
                        "display": id.to_string(),
                        "active": true
                    })
                );
            }

            // TODO: handle result
            return serde_json::to_string_pretty(&json_object).unwrap();
        }
    }
}

pub mod listen {
    use std::{cell::RefCell, rc::Rc};

    use super::*;
    use monitor::*;

    pub fn active(monitor: Rc<RefCell<MonitorContainer<'static>>>) {
        let mut listener = hyprland::event_listener::EventListener::new();

        listener.add_workspace_change_handler(move |_| {
            println!(
                "{}",
                monitor.borrow_mut().get_json()
            );
        });

        // TODO: handle result
        listener.start_listener().unwrap();
    }

    pub fn current(monitor_name: &'static str) {
        let mut listener = hyprland::event_listener::EventListener::new();

        listener.add_workspace_change_handler(move |_| {
            let mut monitors = match hyprland::data::Monitors::get() {
                Ok(m)    => m,
                Err(err) => {
                    eprintln!("{}", err);
                    return ();
                },
            };

            match monitors.find_map(|m|
                if m.name == monitor_name {
                    Some(m)
                } else {
                    None
                }
            )
            {
                Some(m) => println!("{}", m.active_workspace.id),
                None    => {}
            }
        });

        listener.start_listener().unwrap();
    }
}

pub mod action {
    use std::{cell::RefCell, rc::Rc};

    use hyprland::shared::HyprData;

    use super::monitor::MonitorContainer;

    pub fn goto_workspace(workspace_id: i32) {
        use hyprland::dispatch;
        use hyprland::dispatch::*;

        // TODO: handle result
        match hyprland::data::Workspaces::get()
            .unwrap()
            .find_map(|w|
                if w.id == workspace_id {
                    Some(w)
                } else {
                    None
                }
            )
        {
            Some(_) => {
                // TODO: handle result
                dispatch!(
                    Workspace,
                    WorkspaceIdentifierWithSpecial::Id(workspace_id)
                )
                .unwrap();
            },
            None => {},
        }
    }

    pub fn goto_workspace_on_monitor(workspace_id: usize, monitor: Rc<RefCell<MonitorContainer>>) {
        monitor.borrow_mut().goto_workspace(workspace_id);
    }

    pub fn create_workspace(monitor: Rc<RefCell<MonitorContainer>>) {
        monitor.borrow_mut().create_workspace();
    }
}
