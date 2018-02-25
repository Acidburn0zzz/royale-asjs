////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "Licens"); you may not use this file except in compliance with
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
package
{
    COMPILE::SWF
    {
        import flash.utils.Dictionary;
    }
    COMPILE::SWF
    public class Map
    {
        public function Map(iterable:Object=null)
        {
            dict = new Dictionary();
        }

        private var dict:Dictionary;
        public static const length:int = 0;

        private var _keys:Array = [];
        public function get size():int
        {
            return _keys.length;
        }

        public function clear():void
        {
            dict = new Dictionary();
            _keys = [];
        }

        public function delete(key:*):Boolean
        {
            var idx:int = _keys.indexOf(key);
            if(idx != -1){
                _keys.splice(idx,1);
            }
            return delete dict[key];
        }

        //TODO requires Iterator
        // public function entries():Iterator
        // {
            
        // }

        public function forEach(callback:Function,thisArg:Object = null):void
        {
            thisArg = thisArg ? thisArg : this;
            var len:int = _keys.length;
            for(var i:int = 0; i < len; i++)
            {
                callback.call(thisArg,dict[_keys[i]],i,this);
            }
        }

        public function get(key:Object):*
        {
            return dict[key];
        }

        public function has(key:Object):Boolean
        {
            return dict[key] != null;
        }

        //TODO requires Iterator
        // public function keys():Iterator
        // {
            
        // }

        public function set(key:Object,value:*):Map
        {
            dict[key] = value;
            return this;
        }

        //TODO requires Iterator
        // public function values():Iterator
        // {
            
        // }
    }
}