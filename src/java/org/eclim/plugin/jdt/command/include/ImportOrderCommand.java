/**
 * Copyright (C) 2005 - 2009  Eric Van Dewoestine
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.eclim.plugin.jdt.command.include;

import java.lang.reflect.Method;

import org.eclim.annotation.Command;

import org.eclim.command.CommandLine;
import org.eclim.command.Options;

import org.eclim.plugin.core.command.AbstractCommand;

import org.eclim.plugin.core.util.ProjectUtils;

import org.eclipse.core.resources.IProject;

import org.eclipse.core.runtime.IStatus;

import org.eclipse.jdt.internal.ui.preferences.ImportOrganizeConfigurationBlock;
import org.eclipse.jdt.internal.ui.preferences.ImportOrganizeConfigurationBlock.ImportOrderEntry;

import org.eclipse.jdt.internal.ui.wizards.IStatusChangeListener;

import org.eclipse.swt.widgets.Display;

/**
 * Command to retrieve the eclipse configured import order.
 *
 * @author Eric Van Dewoestine
 */
@Command(
  name = "java_import_order",
  options = "REQUIRED p project ARG"
)
public class ImportOrderCommand
  extends AbstractCommand
{
  /**
   * {@inheritDoc}
   * @see org.eclim.command.Command#execute(CommandLine)
   */
  public String execute(CommandLine commandLine)
    throws Exception
  {
    String projectName = commandLine.getValue(Options.PROJECT_OPTION);
    final IProject project = ProjectUtils.getProject(projectName);

    // execute on the user-interface thread to avoid possible NPE when running
    // inside eclipse gui
    final ImportOrderEntry[][] result = new ImportOrderEntry[1][];
    Display.getDefault().syncExec(new Runnable(){
      public void run()
      {
        try{
          ImportOrganizeConfigurationBlock block =
            new ImportOrganizeConfigurationBlock(new IStatusChangeListener(){
              public void statusChanged(IStatus status){
                // no-op
              }
            }, project, null);

          Method getImportOrderPreference = ImportOrganizeConfigurationBlock.class
            .getDeclaredMethod("getImportOrderPreference");
          getImportOrderPreference.setAccessible(true);
          result[0] = (ImportOrderEntry[])getImportOrderPreference.invoke(block);
        }catch(Exception e){
          throw new RuntimeException(e);
        }
      }
    });

    ImportOrderEntry[] entries = result[0];

    StringBuffer buffer = new StringBuffer();
    for (ImportOrderEntry entry : entries){
      if(buffer.length() > 0){
        buffer.append('\n');
      }
      buffer.append(entry.name);
    }
    return buffer.toString();
  }
}
