#![feature(vec_push_within_capacity)]

mod workspaces;
mod args;
mod config;

use clap::Parser;
use workspaces::action;

use crate::workspaces::{listen, monitor};

// TODO: implement proper error handling where ever possible

fn main() {
    let cli_args = args::workspaces::Args::parse();

    match cli_args.command {
        args::workspaces::Command::Active(opts) => {
            let monitor_container = opts.monitor.get();

            if opts.oneshot {
                println!(
                    "{}",
                    monitor_container.borrow_mut().get_json()
                );
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
        args::workspaces::Command::Goto(opts) => {
            match opts.monitor {
                Some(mon) => action::goto_workspace_on_monitor(opts.id, mon.get()),
                None => action::goto_workspace(opts.id as i32),
            }
        },
        args::workspaces::Command::Create(opts) => {
            if opts.window {
                action::window_to_new_workspace(opts.monitor.get());
            } else {
                action::create_workspace(opts.monitor.get());
            }
        }
    }
}
