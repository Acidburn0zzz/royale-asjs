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
goog.provide('spark.components.Label');

goog.require("other.ViewElement");

/**
 * @constructor
 * @extends {other.ViewElement}
 */
spark.components.Label = function() {
	var self = this;
	goog.base(this);
	
	self.element = goog.dom.createDom('div', null, 'Boo!');
}
goog.inherits(spark.components.Label, other.ViewElement);

/**
 * @type {string}
 */
spark.components.Label.prototype.text;
Object.defineProperty(
	spark.components.Label.prototype, 
	'text', 
	{
		get:function() {
			var self = this;
			return self.element.innerHTML;
		},
		set:function(value) {
			var self = this;
			self.element.innerHTML = value;
		}
	}
);
