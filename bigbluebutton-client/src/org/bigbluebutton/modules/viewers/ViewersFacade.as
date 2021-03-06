/**
* BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
*
* Copyright (c) 2008 by respective authors (see below).
*
* This program is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License as published by the Free Software
* Foundation; either version 2.1 of the License, or (at your option) any later
* version.
*
* This program is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
* PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
* 
*/
package org.bigbluebutton.modules.viewers
{
	import org.bigbluebutton.modules.viewers.controller.StartupCommand;
	import org.bigbluebutton.modules.viewers.controller.StopCommand;
	import org.bigbluebutton.modules.viewers.model.vo.User;
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import mx.logging.Log;
	
	/**
	 * The ViewersFacade represents a singleton which holds the Viewers Module together in one instance
	 * @author Denis Zgonjanin
	 * 
	 */	
	public class ViewersFacade extends Facade implements IFacade
	{
		public static const NAME:String = "ViewersFacade";
		
		public static const STARTUP:String = "Startup Command";
		public static const STOP:String = "STOP";
		
		public static const START_VIEWER_WINDOW:String = "Start Viewer Window";
		public static const CHANGE_STATUS:String = "Change Status Event";
		public static const CONNECT_SUCCESS:String = "Connection Successful";
		public static const SERVER_DISCONNECTED:String = "Connection to Server Lost";
		public static const LOGIN_FAILED:String = "Login Failed";
		public static const CONNECT_UNSUCCESSFUL:String = "Connection Unsuccessful";
		public static const VIEW_CAMERA:String = "View Camera";

		public static const DEBUG:String = "Viewer Debug";
		
		/**
		 * The constructor. Should NEVER be called. Use getInstance() instead 
		 * 
		 */		
		public function ViewersFacade()
		{
			super(NAME);
		}
		
		/**
		 * Use this method to get an instance of the ViewersFacade 
		 * @return 
		 * 
		 */		
		public static function getInstance():ViewersFacade{
			if (instanceMap[NAME] == null) instanceMap[NAME] = new ViewersFacade;
			return instanceMap[NAME] as ViewersFacade;
		}
		
		/**
		 * Register notifications to command execution
		 * 
		 */		
		override protected function initializeController():void{
			super.initializeController();
			registerCommand(STARTUP, StartupCommand);
			registerCommand(STOP, StopCommand);
		}
		
		/**
		 * Starts the ViewersModule business logic and gui components 
		 * @param app
		 * 
		 */		
		public function startup(app:ViewersModule):void{
			Log.getLogger("LogController").debug("Viewers Facade is starting up.");
			sendNotification(STARTUP, app);
		}
		
		public function stop(app:ViewersModule):void{
			sendNotification(STOP, app);
		}
		
		public function sendViewCamera(usr:User):void{
			sendNotification(VIEW_CAMERA, usr);
		}

	}
}