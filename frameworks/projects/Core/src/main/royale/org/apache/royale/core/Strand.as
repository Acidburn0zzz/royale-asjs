////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.core
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.utils.beads.sendLookupNotifications;
	import org.apache.royale.utils.beads.insertInterests;
	import org.apache.royale.utils.beads.removeInterests;

    /**
     *  The Strand class is the base class for non-display object
     *  that implement a strand.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class Strand implements IStrand
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function Strand()
		{
			super();
		}
		
		
		private var _model:IBeadModel;
                
        /**
         *  An IBeadModel that serves as the data model for the component.
         *  Note that there is no controller or view properties since
         *  this not a display object.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         *  @royaleignorecoercion org.apache.royale.core.IBead
         */
		public function get model():IBeadModel
		{
            if (_model == null)
            {
                // addbead will set _model
                addBead(new (ValuesManager.valuesImpl.getValue(this, "iBeadModel")) as IBead);
            }
			return _model;
		}
        
        /**
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.IBead
         */
		public function set model(value:IBeadModel):void
		{
			if (_model != value)
			{
				addBead(value as IBead);
                notify("modelChanged");
			}
		}
		
		private var _id:String;

        /**
         *  An id property for MXML documents.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get id():String
		{
			return _id;
		}
		public function set id(value:String):void
		{
			if (_id != value)
			{
				_id = value;
                notify("idChanged");
			}
		}
				
        /**
         *  @copy org.apache.royale.core.Application#beads
         *  
         *  The beads are not automatically added to the
         *  strand.  Subclasses must decide when to
         *  add the beads.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
         */
		public var beads:Array;
		
		private var _beads:Vector.<IBead>;

        /**
         *  @copy org.apache.royale.core.IStrand#addBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         *  @royaleignorecoercion org.apache.royale.core.IBeadModel
         */
		public function addBead(bead:IBead):void
		{
			if (!_beads)
				_beads = new Vector.<IBead>;
			_beads.push(bead);
			if (bead is IBeadModel)
				_model = bead as IBeadModel;
			bead.strand = this;
            insertInterests(beadLookup,bead);
		}
		
        /**
         *  @copy org.apache.royale.core.IStrand#getBeadByType()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function getBeadByType(classOrInterface:Class):IBead
		{
			for each (var bead:IBead in _beads)
			{
				if (bead is classOrInterface)
					return bead;
			}
			return null;
		}
		
        /**
         *  @copy org.apache.royale.core.IStrand#removeBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function removeBead(value:IBead):IBead	
		{
			var n:int = _beads.length;
			for (var i:int = 0; i < n; i++)
			{
				var bead:IBead = _beads[i];
				if (bead == value)
				{
					_beads.splice(i, 1);
                    removeInterests(beadLookup,bead);
					return bead;
				}
			}
			return null;
		}

        /**
         * The beadLookup keeps references to beads using their notification interests
         */
        protected var beadLookup:Object = {};

        /**
         *  Sends a notification instance.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function sendNotification(notification:INotification):void{
            sendLookupNotifications(beadLookup,notification);
        }

        /**
         *  Simplified method for sending notifications.
         *  Use when body is not significant.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        public function notify(message:String):void{
            var notification:INotification = new Notification(message);
            sendNotification(notification);
        }
	}
}
