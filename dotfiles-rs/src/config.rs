pub mod workspaces {
    use clap::ValueEnum;
    use std::{rc::Rc, cell::RefCell};
    use crate::workspaces::monitor::MonitorContainer;
    use hyprland::{data::CursorPosition, shared::HyprData};

    macro_rules! new_monitor {
        ($monitor:expr, $(($id:expr => $display:expr)),*) => {
            {
                let m = Rc::new(RefCell::new(MonitorContainer::new($monitor)));

                $(
                    m.borrow_mut().add_named_workspace($id, $display)
                );*;

                m
            }
        };
    }

    pub const NAMED_ALLOC:   usize = 4;
    pub const UNNAMED_ALLOC: usize = 6;

    // TODO: we probably want a better way for configuration

    #[derive(Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord, ValueEnum)]
    pub enum MonitorPreset {
        Primary,
        Secondary,
        // add presets here...
        Auto
    }

    impl MonitorPreset {

        fn auto(&self) -> Self {
            // configure how monitor should be selected when "auto" keyword is used
            return if CursorPosition::get().unwrap().x > 2560 {
                Self::Primary
            } else {
                Self::Secondary
            }
        }

        pub fn get(&self) -> Rc<RefCell<MonitorContainer<'static>>> {
            return match self {
                Self::Primary => new_monitor!(
                    self.get_name(),
                    (1 => ""),
                    (2 => ""),
                    (3 => "󱅯"),
                    (4 => "")
                ),
                Self::Secondary => new_monitor!(
                    self.get_name(),
                    (11 => ""),
                    (12 => ""),
                    (13 => ""),
                    (14 => "")
                ),
                // configure workspaces for presets here...
                Self::Auto => self.auto().get()
            };
        }

        pub fn get_name(&self) -> &'static str {
            return match self {
                Self::Primary   => "DP-1",
                Self::Secondary => "HDMI-A-1",
                // configure monitor names for presets here...
                Self::Auto      => self.auto().get_name()
            };
        }
    }
}
