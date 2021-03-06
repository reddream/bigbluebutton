package org.bigbluebutton.main.managers
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	import mx.modules.ModuleLoader;
	
	import org.bigbluebutton.common.IBigBlueButtonModule;
	import org.bigbluebutton.main.events.ModuleEvent;

	public class ModuleDescriptor
	{
		private var _attributes:Object;
		private var _loader:ModuleLoader;
		private var _module:IBigBlueButtonModule;
		private var _loaded:Boolean = false;
		private var _started:Boolean = false;
		private var _connected:Boolean = false;
				
		public var dispatcher : IEventDispatcher;
		
		public function ModuleDescriptor(attributes:XML)
		{
			_attributes = new Object();
			_loader = new ModuleLoader();
			
			parseAttributes(attributes);			
		}

		public function addAttribute(attribute:String, value:Object):void {
			_attributes[attribute] = value;
		}
		
		public function getAttribute(name:String):Object {
			return _attributes[name];
		}
		
		public function get attributes():Object {
			return _attributes;
		}
		
		public function get module():IBigBlueButtonModule {
			return _module;
		}
		
		public function get loaded():Boolean {
			return _loaded;
		}
		
		public function set started(value:Boolean):void {
			_started = value;
		}
		
		private function parseAttributes(item:XML):void {
			var attNamesList:XMLList = item.@*;

			for (var i:int = 0; i < attNamesList.length(); i++)
			{ 
			    var attName:String = attNamesList[i].name();
			    var attValue:String = item.attribute(attName);
			    _attributes[attName] = attValue;
			} 
		}
				
		public function load(dispatcher:IEventDispatcher):void {
			this.dispatcher = dispatcher;
//			loader.addEventListener("urlChanged", resultHandler);
//			loader.addEventListener("loading", resultHandler);
			_loader.addEventListener("progress", onLoadProgress);
//			loader.addEventListener("setup", resultHandler);
			_loader.addEventListener("ready", onReady);
//			loader.addEventListener("error", resultHandler);
//			loader.addEventListener("unload", resultHandler);
			_loader.url = _attributes.url;
			_loader.loadModule();
		}
		
		public function unload():void {
			_loader.url = "";
		}

		private function onReady(event:Event):void {
			LogUtil.debug("Module onReady Event");
			var modLoader:ModuleLoader = event.target as ModuleLoader;
			_module = modLoader.child as IBigBlueButtonModule;
			var moduleName:String = _attributes.name;
			if (_module != null) {
				LogUtil.debug("Module " + moduleName + " has been loaded");
				_loaded = true;
				
				var loadEvent:ModuleEvent = new ModuleEvent(ModuleEvent.MODULE_LOADED_EVENT);
				loadEvent.moduleName = moduleName;
				dispatcher.dispatchEvent(loadEvent);
			} else {
				LogUtil.error("Module loaded is null.");
				var loadErrorEvent:ModuleEvent = new ModuleEvent(ModuleEvent.MODULE_LOAD_ERROR_EVENT);
				loadErrorEvent.moduleName = moduleName;
				loadErrorEvent.message = "Failed to load " + moduleName;
				dispatcher.dispatchEvent(loadErrorEvent);
			}			
		}	

		private function onLoadProgress(e:ProgressEvent):void {
			var loadProgressEvent:ModuleEvent = new ModuleEvent(ModuleEvent.MODULE_LOAD_PROGRESS_EVENT);
			loadProgressEvent.moduleName = _attributes.name;
			loadProgressEvent.percentLoaded = Math.round((e.bytesLoaded/e.bytesTotal) * 100);
			dispatcher.dispatchEvent(loadProgressEvent);
		}	
		
/*
		private function onUrlChanged(event:Event):void {
			LogUtil.debug("Module onUrlChanged Event");
			callbackHandler(event);
		}
			
		private function onLoading(event:Event):void {
			LogUtil.debug("Module onLoading Event");
			callbackHandler(event);
		}
			
		private function onProgress(event:Event):void {
			LogUtil.debug("Module onProgress Event");
			callbackHandler(event);
		}			

		private function onSetup(event:Event):void {
			LogUtil.debug("Module onSetup Event");
			callbackHandler(event);
		}	



		private function onError(event:Event):void {
			LogUtil.debug("Module onError Event");
			callbackHandler(event);
		}

		private function onUnload(event:Event):void {
			LogUtil.debug("Module onUnload Event");
			callbackHandler(event);
		}		
*/
	}
}