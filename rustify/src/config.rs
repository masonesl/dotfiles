pub mod workspaces {
    use clap::ValueEnum;
    use std::{rc::Rc, cell::RefCell};
    use crate::workspaces as workspaces_main;

    macro_rules! new_monitor {
        ($monitor:expr, $($workspaces:expr),*) => {
            {
                let m = Rc::new(RefCell::new(workspaces_main::monitor::MonitorContainer::new($monitor)));

                $(
                    m.borrow_mut().add_named_workspace($workspaces.0, $workspaces.1)
                );*;

                m
            }
        };

        ($monitor:expr, named $named_size:expr, unnamed $unnamed_size:expr, $($workspaces:expr),*) => {
            {
                let m = Rc::new(RefCell::new(workspaces_main::monitor::MonitorContainer::new_with_alloc($monitor, $named_size, $unnamed_size)));

                $(
                    m.borrow_mut().add_named_workspace($workspaces.0, $workspaces.1)
                );*;

                m
            }
        };
    }


    #[derive(Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord, ValueEnum)]
    pub enum MonitorPreset {
        Primary,
        Secondary,
    }

    impl MonitorPreset {
        pub fn get(&self) -> Rc<RefCell<workspaces_main::monitor::MonitorContainer<'static, 'static>>> {
            return match self {
                MonitorPreset::Primary => new_monitor!(
                    "DP-1",
                    (1, ""),
                    (2, ""),
                    (3, "󱅯"),
                    (4, "")
                ),
                MonitorPreset::Secondary => new_monitor!(
                    "HDMI-A-1",
                    (11, ""),
                    (12, ""),
                    (13, ""),
                    (14, "")
                ),
            };
        }

        pub fn get_name(&self) -> &'static str {
            return match self {
                MonitorPreset::Primary   => "DP-1",
                MonitorPreset::Secondary => "HDMI-A-1",
            };
        }
    }
}
