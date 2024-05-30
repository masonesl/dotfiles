use clap::{Args, Parser, Subcommand};

pub mod workspaces {
    use super::*;
    use crate::config;

    #[derive(Parser, Debug)]
    pub struct Args {
        #[command(subcommand)]
        pub command: Command,
    }

    #[derive(Subcommand, Debug)]
    pub enum Command {
        Active(ListenArgs),
        Current(ListenArgs),

        Goto(GotoArgs),

        Create(CreateArgs),
    }

    #[derive(Args, Debug)]
    pub struct ListenArgs {
        #[arg(value_enum)]
        pub monitor: config::workspaces::MonitorPreset,

        #[arg(short, long)]
        pub oneshot: bool,
    }

    #[derive(Args, Debug)]
    pub struct GotoArgs {
        #[arg()]
        pub id: usize,

        #[arg(value_enum)]
        pub monitor: Option<config::workspaces::MonitorPreset>,
    }

    #[derive(Args, Debug)]
    pub struct CreateArgs {
        #[arg(value_enum)]
        pub monitor: config::workspaces::MonitorPreset,
    }
}
