use hyprland::{
    self,
    shared::{
        HyprData as _, HyprError
    }
};

#[derive(Debug)]
struct NamedWorkspace<'a> {
    unique_id: usize,
    display_name: &'a str,
    is_active: bool,
}

impl<'a> NamedWorkspace<'a> {
    fn new(unique_id: usize, display_name: &'a str) -> Self {
        return Self {
            unique_id,
            display_name,
            is_active: false,
        };
    }

    fn print_json(&self) {
        print!("\"{}\": {{", self.unique_id);
        print!("\"display\": \"{}\",", self.display_name);
        print!("\"active\": {}", self.is_active);
        print!("}}");
    }

    fn find_by_id_mut(list: &mut Vec<Self>, id: usize) -> Option<&mut Self> {
        return list
            .iter_mut()
            .find_map(|named| {
                if named.unique_id == id {
                    Some(named)
                } else {
                    None
                }
            });
    }

    fn find_by_id(list: &Vec<Self>, id: usize) -> Option<&Self> {
        return list
            .iter()
            .find_map(|named| {
                if named.unique_id == id {
                    Some(named)
                } else {
                    None
                }
            });
    }
}

pub mod monitor {
    use core::panic;

    use super::*;
    use crate::config::workspaces::{NAMED_ALLOC, UNNAMED_ALLOC};

    const ALL_ALLOC: usize = NAMED_ALLOC + UNNAMED_ALLOC;

    pub struct MonitorContainer<'a> {
        unique_name: &'a str,                      // unique monitor name (ie. HDMI-A-1)
        named_workspaces: Vec<NamedWorkspace<'a>>, // workspaces that should always be shown
        unnamed_workspaces: Vec<usize>,            // workspaces that should be shown if they exist
    }

    impl<'a> MonitorContainer<'a> {
        #[allow(unused)]
        pub fn new(unique_name: &'a str) -> Self {
            return Self {
                unique_name,
                named_workspaces: Vec::<NamedWorkspace>::with_capacity(NAMED_ALLOC),
                unnamed_workspaces: Vec::<usize>::with_capacity(UNNAMED_ALLOC),
            };
        }

        pub fn add_named_workspace(&mut self, unique_id: usize, display_name: &'a str) {
            /* NOTICE: push_within_capacity() is currently considered unstable! */
            self.named_workspaces
                .push_within_capacity(NamedWorkspace::new(unique_id, display_name))
                .unwrap();
        }

        pub fn update(&mut self) {
            // set all workspaces to inactive
            self.named_workspaces
                .iter_mut()
                .for_each(|named| named.is_active = false);

            self.unnamed_workspaces.clear();

            let workspaces = hyprland::data::Workspaces::get().unwrap();

            for workspace in workspaces {
                // ignore workspaces not on specified monitor
                if workspace.monitor != self.unique_name {
                    continue;
                }

                match NamedWorkspace::find_by_id_mut(&mut self.named_workspaces, workspace.id as usize) {
                    Some(named) => named.is_active = true,
                    None => {
                        self.unnamed_workspaces
                            .push_within_capacity(workspace.id as usize)
                            .unwrap();
                    },
                };

            }
        }

        pub fn goto_workspace(&mut self, workspace_id: usize) {
            use hyprland::dispatch::*;

            self.update();

            /* Use the smallest id in the named workspaces as the first workspace on
             * the monitor. This assumes that both named and unnamed workspaces are
             * ordered and that the unnamed workspaces come directly after the named. */

            let absolute_id = match self.named_workspaces
                .iter()
                .min_by(|a, b| a.unique_id.cmp(&b.unique_id)) {

                Some(first) => first.unique_id + workspace_id - 1,
                None        => panic!(),
            };

            let id = match NamedWorkspace::find_by_id(&self.named_workspaces, absolute_id)
            {
                Some(_) => absolute_id,
                None    => {
                    match self.unnamed_workspaces
                        .iter()
                        .find(absolute_id)
                    {
                        Some(_) => absolute_id,
                        None => panic!(),
                    }
                },
            };

            Dispatch::call(
                DispatchType::Workspace(
                    WorkspaceIdentifierWithSpecial::Id(id as i32)
                )
            ).unwrap();
        }

        pub fn print_json(&mut self) -> Result<(), HyprError> {
            self.update()?;

            // output a json object containing each workspace to be displayed with the format:
            //
            // {
            //   "id" : {
            //     display: "display name",
            //     active: true|false,
            //   },
            //   ...
            // }

            print!("{{");

            /* To avoid json parsers getting mad about a trailing comma, print the first
             * workspace without a comma, then print the rest with a comma before. */

            match self.named_workspaces.first() {
                Some(first) => first.print_json(),
                None        => {},
            }

            match self.named_workspaces.get(1..) {
                Some(workspaces) => {
                    workspaces.iter().for_each(|named| {
                        print!(", ");     
                        named.print_json();
                    });
                },
                None => {},
            };

            // do the same for the unnamed workspaces
            match self.unnamed_workspaces.first() {
                Some(first) => {
                    if self.named_workspaces.len() > 0 {
                        print!(", ");
                    }
                    first.print_json(CLAMP);
                },
                None => {},
            }

            match self.unnamed_workspaces.get(1..) {
                Some(workspaces) => {
                    workspaces.iter().for_each(|unnamed| {
                        print!(", ");     
                        unnamed.print_json(CLAMP);
                    });
                },
                None => {},
            }

            println!("}}");

            return Ok(());
        }
    }
}

pub mod listen {
    use std::{cell::RefCell, rc::Rc};

    use super::*;
    use monitor::*;

    use crate::config;

    pub fn active(monitor: Rc<RefCell<MonitorContainer<'static>>>) {
        let mut listener = hyprland::event_listener::EventListener::new();

        listener.add_workspace_change_handler(move |_| {
            match monitor.borrow_mut().print_json() {
                Ok(_)    => {},
                Err(err) => {
                    eprintln!("{}", err);
                    return ();
                },
            }
        });

        listener.start_listener().unwrap();
    }

    pub fn current(monitor_name: &'static str) {
        let mut listener = hyprland::event_listener::EventListener::new();

        listener.add_workspace_change_handler(move |_| {
            let monitors = match hyprland::data::Monitors::get() {
                Ok(m)    => m,
                Err(err) => {
                    eprintln!("{}", err);
                    return ();
                },
            };

            for mon in monitors {
                if mon.name == monitor_name {
                    println!("{}", mon.active_workspace.id);
                    break;
                }
            }
        });

        listener.start_listener().unwrap();
    }
}

pub mod action {
    use std::{cell::RefCell, rc::Rc};

    use hyprland::{dispatch::*, shared::HyprData};

    use super::monitor::MonitorContainer;

    pub fn goto_workspace(workspace_id: i32) {
        match hyprland::data::Workspaces::get().unwrap().find_map(|w| {
            if w.id == workspace_id {
                Some(w)
            } else {
                None
            }
        }) {
            Some(_) => {
                Dispatch::call(
                    DispatchType::Workspace(
                        WorkspaceIdentifierWithSpecial::Id(workspace_id)
                    )
                ).unwrap();
            },
            None => {},
        }
    }

    pub fn goto_workspace_on_monitor(workspace_id: usize, monitor: Rc<RefCell<MonitorContainer>>) {
        monitor.borrow_mut().goto_workspace(workspace_id);
    }
}
