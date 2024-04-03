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
    }

    #[derive(Args, Debug)]
    pub struct ListenArgs {
        #[arg(value_enum)]
        pub monitor: config::workspaces::MonitorPreset,

        #[arg(short, long)]
        pub oneshot: bool,
    }

}
