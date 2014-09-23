/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.core.Application');

goog.require('org.apache.flex.core.HTMLElementWrapper');
goog.require('org.apache.flex.core.SimpleValuesImpl');
goog.require('org.apache.flex.core.ValuesManager');
goog.require('org.apache.flex.utils.MXMLDataInterpreter');



/**
 * @constructor
 * @extends {org.apache.flex.core.HTMLElementWrapper}
 */
org.apache.flex.core.Application = function() {
  org.apache.flex.core.Application.base(this, 'constructor');
};
goog.inherits(org.apache.flex.core.Application,
    org.apache.flex.core.HTMLElementWrapper);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.Application.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Application',
                qName: 'org.apache.flex.core.Application' }] };


/**
 * @expose
 * @type {Object}
 */
org.apache.flex.core.Application.prototype.controller = null;


/**
 * @expose
 * @type {Object}
 */
org.apache.flex.core.Application.prototype.initialView = null;


/**
 * @expose
 * @type {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.core.Application.prototype.model = null;


/**
 * @expose
 * @type {org.apache.flex.core.SimpleValuesImpl}
 */
org.apache.flex.core.Application.prototype.valuesImpl = null;


/**
 * @expose
 */
org.apache.flex.core.Application.prototype.start = function() {
  this.element = document.getElementsByTagName('body')[0];
  this.element.flexjs_wrapper = this;

  org.apache.flex.core.ValuesManager.valuesImpl = this.valuesImpl;
  if (this.valuesImpl.init) {
    this.valuesImpl.init(this);
  }

  this.dispatchEvent('initialize');

  this.initialView.applicationModel = this.model;
  this.addElement(this.initialView);

  this.dispatchEvent('viewChanged');
};


/**
 * @expose
 * @param {Array} data The data for the attributes.
 */
org.apache.flex.core.Application.prototype.generateMXMLAttributes = function(data) {
  org.apache.flex.utils.MXMLDataInterpreter.generateMXMLProperties(this, data);
};


/**
 * @param {Object} c The child element.
 */
org.apache.flex.core.Application.prototype.addElement =
    function(c) {
  this.element.appendChild(c.element);
  c.addedToParent();
};

