use hyprland::{self, shared::{HyprData as _, HyprError}};

struct NamedWorkspace<'a> {
    unique_id: usize,
    display_name: &'a str,
    is_active: bool,
}

struct UnnamedWorkspace {
    unique_id: usize,
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
}

impl UnnamedWorkspace {
    fn print_json(&self, display_id_clamp: usize) {
        print!("\"{}\": {{", self.unique_id);
        print!("\"display\": \"{}\",", self.unique_id % display_id_clamp);
        print!("\"active\": true");
        print!("}}");
    }
}

pub mod monitor {
    use super::*;

    static NAMED_ALLOC: usize = 4;
    static UNNAMED_ALLOC: usize = 6;

    pub struct MonitorContainer<'a, 'b> {
        unique_name: &'b str,                      // unique monitor name (ie. HDMI-A-1)
        named_workspaces: Vec<NamedWorkspace<'a>>, // workspaces that should always be shown
        unnamed_workspaces: Vec<UnnamedWorkspace>, // workspaces that should be shown if they exist
    }

    impl<'a, 'b> MonitorContainer<'a, 'b> {
        pub fn new(unique_name: &'b str) -> Self {
            return Self {
                unique_name,
                named_workspaces: Vec::<NamedWorkspace>::with_capacity(NAMED_ALLOC),
                unnamed_workspaces: Vec::<UnnamedWorkspace>::with_capacity(UNNAMED_ALLOC),
            };
        }

        pub fn new_with_alloc(unique_name: &'b str, named_alloc: usize, unnamed_alloc: usize) -> Self {
            return Self {
                unique_name,
                named_workspaces: Vec::<NamedWorkspace>::with_capacity(named_alloc),
                unnamed_workspaces: Vec::<UnnamedWorkspace>::with_capacity(unnamed_alloc),
            };
        }

        pub fn add_named_workspace(&mut self, unique_id: usize, display_name: &'a str) {
            self.named_workspaces
                .push(NamedWorkspace::new(unique_id, display_name));
        }

        pub fn print_json(&mut self) -> Result<(), HyprError> {
            // set all workspaces to inactive
            self.named_workspaces.iter_mut().for_each(|named| named.is_active = false);
            self.unnamed_workspaces.clear();

            let workspaces = hyprland::data::Workspaces::get()?;
            let workspace_id_clamp = self.named_workspaces.len() + self.unnamed_workspaces.capacity();

            for workspace in workspaces {
                // ignore workspaces not on specified monitor
                if workspace.monitor != self.unique_name {
                    continue;
                }

                let relative_workspace_id = (workspace.id as usize - 1) % workspace_id_clamp; 

                if relative_workspace_id < self.named_workspaces.len() {
                    self.named_workspaces[relative_workspace_id].is_active = true;
                } else {
                    self.unnamed_workspaces.push(UnnamedWorkspace{unique_id: workspace.id as usize});
                }
            }

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
                        print!(",");     
                        named.print_json();
                    });
                },
                None => {},
            };

            // do the same for the unnamed workspaces
            match self.unnamed_workspaces.first() {
                Some(first) => {
                    if self.named_workspaces.len() > 0 {
                        print!(",");
                    }
                    first.print_json(workspace_id_clamp);
                },
                None => {},
            }

            match self.unnamed_workspaces.get(1..) {
                Some(workspaces) => {
                    workspaces.iter().for_each(|unnamed| {
                        print!(",");     
                        unnamed.print_json(workspace_id_clamp)
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

    pub fn active(monitor: Rc<RefCell<MonitorContainer<'static, 'static>>>) {
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
}

