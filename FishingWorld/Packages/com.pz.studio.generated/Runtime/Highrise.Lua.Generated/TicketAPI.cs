/*

    Copyright (c) 2024 Pocketz World. All rights reserved.

    This is a generated file, do not edit!

    Generated by com.pz.studio
*/

#if UNITY_EDITOR

using System;
using System.Linq;
using UnityEngine;
using Highrise.Client;
using Highrise.Studio;
using Highrise.Lua;

namespace Highrise.Lua.Generated
{
    [AddComponentMenu("Lua/TicketAPI")]
    [LuaRegisterType(0xa9a7ae18ec8b21a7, typeof(LuaBehaviour))]
    public class TicketAPI : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "8f92d4a1d1ce39e4ba86b70b479c6356";
        public override string ScriptGUID => s_scriptGUID;


        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
            };
        }
    }
}

#endif
