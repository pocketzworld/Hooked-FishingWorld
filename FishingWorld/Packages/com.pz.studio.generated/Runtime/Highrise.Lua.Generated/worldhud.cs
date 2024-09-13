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
    [AddComponentMenu("Lua/worldhud")]
    [LuaRegisterType(0x9268b3b8c7e46248, typeof(LuaBehaviour))]
    public class worldhud : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "7252a39f037c9d94880a19af629a0163";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public UnityEngine.Texture m_emptyPoleIcon = default;
        [SerializeField] public UnityEngine.Texture m_emptyBaitIcon = default;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_emptyPoleIcon),
                CreateSerializedProperty(_script.GetPropertyAt(1), m_emptyBaitIcon),
                CreateSerializedProperty(_script.GetPropertyAt(2), null),
                CreateSerializedProperty(_script.GetPropertyAt(3), null),
                CreateSerializedProperty(_script.GetPropertyAt(4), null),
                CreateSerializedProperty(_script.GetPropertyAt(5), null),
                CreateSerializedProperty(_script.GetPropertyAt(6), null),
                CreateSerializedProperty(_script.GetPropertyAt(7), null),
                CreateSerializedProperty(_script.GetPropertyAt(8), null),
                CreateSerializedProperty(_script.GetPropertyAt(9), null),
                CreateSerializedProperty(_script.GetPropertyAt(10), null),
                CreateSerializedProperty(_script.GetPropertyAt(11), null),
                CreateSerializedProperty(_script.GetPropertyAt(12), null),
                CreateSerializedProperty(_script.GetPropertyAt(13), null),
            };
        }
    }
}

#endif
