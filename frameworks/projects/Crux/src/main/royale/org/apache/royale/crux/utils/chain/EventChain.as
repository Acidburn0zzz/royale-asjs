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
/***
 * Based on the
 * Swiz Framework library by Chris Scott, Ben Clinkinbeard, Sönke Rohde, John Yanarella, Ryan Campbell, and others https://github.com/swiz/swiz-framework
 */
package org.apache.royale.crux.utils.chain
{
	import org.apache.royale.events.IEventDispatcher;
	
	public class EventChain extends BaseCompositeChain
	{
		// ========================================
		// protected properties
		// ========================================

		/**
		 * Backing variable for <code>dispatcher</code> getter/setter.
		 */
		protected var _dispatcher:IEventDispatcher;
		
		// ========================================
		// public properties
		// ========================================

		/**
		 * Target Event dispatcher.
		 */
		public function get dispatcher():IEventDispatcher
		{
			return _dispatcher;
		}
		
		public function set dispatcher( value:IEventDispatcher ):void
		{
			_dispatcher = value;
		}
		
		// ========================================
		// constructor
		// ========================================

		/**
		 * Constructor.
		 */
		public function EventChain(dispatcher:IEventDispatcher, mode:String = ChainType.SEQUENCE, stopOnError:Boolean = true )
		{
			super( mode, stopOnError );
			
			this.dispatcher = dispatcher;
		}
		
		// ========================================
		// public methods
		// ========================================
		
		/**
		 * Add an EventChainStep to this EventChain.
		 */
		public function addEvent( event:EventChainStep ):EventChain
		{
			addStep( event );
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function doProceed():void
		{
			if( currentStep is EventChainStep )
				EventChainStep( currentStep ).dispatcher ||= dispatcher;
			
			super.doProceed();
		}
	}
}
