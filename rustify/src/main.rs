mod workspaces;
mod args;

use clap::Parser;

use crate::workspaces::{listen, monitor};



fn main() {
    let cli_args = args::workspaces::Args::parse();

    match cli_args.command {
        args::workspaces::Command::Active(opts) => {
            let monitor_container = opts.monitor.get();

            if opts.oneshot {
                todo!();
            } else {
                listen::active(monitor_container);
            }
        },
        args::workspaces::Command::Current(opts) => {
            let monitor_name = opts.monitor.get_name();

            if opts.oneshot {
                todo!();
            } else {
                listen::current(monitor_name);
            }
        },
    }
}
