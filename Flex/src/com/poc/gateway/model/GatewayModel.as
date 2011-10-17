package com.poc.gateway.model
{
	import com.adobe.serialization.json.JSON;
	import com.poc.gateway.controller.events.EntryEvent;
	import com.poc.gateway.model.vo.EntryVO;
	import com.poc.gateway.model.vo.PersonVO;
	import com.poc.gateway.model.vo.RoleVO;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	
	public class GatewayModel extends Actor
	{
		public var _entries:ArrayCollection = new ArrayCollection();
		
		public var Employees:ArrayCollection = new ArrayCollection();
		public var Roles:ArrayCollection = new ArrayCollection();
		
		private var employeeFile:File;
		private var entryFile:File;
		
		private var _lastSwipe:EntryVO;
		
/*		private var time:Timer;
		private var currentTime:Date;
		public function set lastSwipe(param:EntryVO):void
		{
			
			this.currentTime = param;
			var e : ModelEvent = new ModelEvent(
				ModelEvent.VALID_SWIPE);
			dispatch( e );
		}
		
		}*/
		private var _currentSwipeInspection:EntryVO;

		public function get currentSwipeInspection():EntryVO
		{
			return _currentSwipeInspection;
		}

		public function set currentSwipeInspection(value:EntryVO):void
		{
			_currentSwipeInspection = value;
			var e : ModelEvent = new ModelEvent(
				ModelEvent.CURRENT_INSPECTION_CHANGED);
			dispatch( e );
		}
		
		
		public function set lastSwipe(param:EntryVO):void
		{
			this._lastSwipe = param;
			var e : ModelEvent = new ModelEvent(
				ModelEvent.VALID_SWIPE);
				dispatch( e );
		}
		
		public function get lastSwipe():EntryVO
		{
			
			return _lastSwipe;
		}
		public function GatewayModel()
		{
			readRoles();
			readEmployees();
			setupLog();
		} 
		public function readEmployees():void
		{
			

			
			/*read employees.txt for each Employees JSON defintion*/
			var file:File = File.documentsDirectory.resolvePath("employees.txt");
			var fileStream:FileStream = new FileStream();
			var rawJSON:String;
			var _json:Object
			
			fileStream.open(file, FileMode.READ);
			try{
				rawJSON= fileStream.readUTFBytes(fileStream.bytesAvailable);
			}
			catch(e:Error){}
			fileStream.close();
			if(rawJSON != null)
				_json = JSON.decode(rawJSON);
			
			for each( var employeeImport:Object in _json.Employees  )
			{
				var employee:PersonVO = new PersonVO;
				employee.Name = employeeImport.name
				employee.cardID = employeeImport.cardid;
				employee.Role = this.Roles[employeeImport.role];
				employee.created = employeeImport.created;
				employee.deleted = employeeImport.deleted;
					
				this.Employees.addItem(employee);
			}
			
			

			
		}
		public function writeEmployees():void
		{
			
			
			var file:File = File.documentsDirectory.resolvePath("employeesOUT.txt");
			var fileStream:FileStream = new FileStream();
			
			var export:Object = new Object();
			export.Employees = new Array();
			for each(var person:PersonVO in this.Employees)
			{
				var newperson:Object = new Object();
				newperson.name = person.Name;
				newperson.cardid = person.cardID;
				newperson.rate = person.Role;
				newperson.created = person.created;
				newperson.deleted = person.deleted;
				
				(export.Employees as Array).push(newperson);
			}
			
			var exportstring:String = JSON.encode(export);
			
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTF(exportstring);
			fileStream.close();
		}
		public function setupLog():void
		{
			var date : Date = new Date();
			var filename:String = 'event' + date.getTime();
			var file:File = File.documentsDirectory.resolvePath(filename);
			var fileStream:FileStream = new FileStream();
			/*fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTF("test");
			fileStream.close();*/
		}

		public function readRoles():void
		{
			/*read roles.txt for Roles each employee can have*/
			var file:File = File.documentsDirectory.resolvePath("roles.txt");
			var fileStream:FileStream = new FileStream();
			var rawJSON:String;
			var _json:Object;
			
			fileStream.open(file, FileMode.READ);
			try{
				rawJSON = fileStream.readUTFBytes(fileStream.bytesAvailable);
			}
			catch(e:Error){}
			fileStream.close();
			if(rawJSON != null)
				_json = JSON.decode(rawJSON);
			
			for each( var roleImport:Object in _json.roles  )
			{
				var role:RoleVO = new RoleVO();
				role.Name = roleImport.label
				role.Index = roleImport.index;
				role.Rate = roleImport.rate;
				role.Color = roleImport.color;
				this.Roles.addItemAt(role,role.Index);
			}
		}
		
		
	}
}