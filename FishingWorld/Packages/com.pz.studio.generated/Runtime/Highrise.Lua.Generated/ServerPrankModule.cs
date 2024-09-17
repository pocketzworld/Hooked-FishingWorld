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
    [AddComponentMenu("Lua/ServerPrankModule")]
    [LuaRegisterType(0x2a364a61b37e61a8, typeof(LuaBehaviour))]
    public class ServerPrankModule : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "0246a48c7afcf2840a115aaa09975ca9";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public System.Boolean m_testMode = false;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_testMode),
            };
        }
    }
}

#endif