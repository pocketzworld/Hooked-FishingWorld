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
    [AddComponentMenu("Lua/FishIconWorld")]
    [LuaRegisterType(0x780a16dfce8f51de, typeof(LuaBehaviour))]
    public class FishIconWorld : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "79a6c95975dac2646be1d34852029673";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public UnityEngine.Texture m_img = default;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_img),
                CreateSerializedProperty(_script.GetPropertyAt(1), null),
            };
        }
    }
}

#endif
