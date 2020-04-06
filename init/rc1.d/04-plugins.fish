#!/usr/bin/env fish

# functions for managing plugins

define_command plugin "Tools to help manage fishdots plugins"
define_subcommand plugin home on_plugin_home "switch to plugin home folder"
define_subcommand plugin ls on_plugin_ls "list all installed plugins"
define_subcommand plugin sync on_plugin_sync "save and push any changes to the plugin"
define_subcommand plugin install on_plugin_install "install a plugin"
define_subcommand plugin uninstall on_plugin_uninstall "uninstall a plugin"

function plugin_install -e on_plugin_install -a git_url name
  _fd_enter $FISHDOTS_PLUGINS_HOME
 
  if test -e $name
    warn "Plugin is already installed"
  end

  git clone $git_url $name
  _fd_leave
end

function plugin_home -e on_plugin_home
  cd $FISHDOTS_PLUGINS_HOME
end

function plugin_uninstall -e on_plugin_uninstall -a name
  # just delete it  (?? OR check if there are uncommitted changes first ??)
  _fd_enter $FISHDOTS_PLUGINS_HOME

  if test -e $name
    rm -rf $name
  end

  _fd_leave
end

function plugin_list -e on_plugin_ls
  for p in (find $FISHDOTS_PLUGINS_HOME -maxdepth 1 -mindepth 1 -type d 2>/dev/null)
    echo (basename $p)
  end
end

function plugin_sync -e on_plugin_sync -d "synchronise all plugin folders"
  for i in (ls $FISHDOTS_PLUGINS_HOME)
    fishdots_git_sync $FISHDOTS_PLUGINS_HOME/$i "more tinkering"
  end
end
