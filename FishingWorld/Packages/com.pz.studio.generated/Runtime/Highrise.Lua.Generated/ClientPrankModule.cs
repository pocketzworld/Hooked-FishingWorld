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
    [AddComponentMenu("Lua/ClientPrankModule")]
    [LuaRegisterType(0xec3492f38e9541b4, typeof(LuaBehaviour))]
    public class ClientPrankModule : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "c22504cc2f6d36745a6206e3aac3b8e5";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public UnityEngine.Texture2D m_freeActionImage = default;
        [SerializeField] public UnityEngine.Texture2D m_guaranteedActionImage = default;
        [SerializeField] public UnityEngine.Texture2D m_guaranteedDoubleActionImage = default;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_freeActionImage),
                CreateSerializedProperty(_script.GetPropertyAt(1), m_guaranteedActionImage),
                CreateSerializedProperty(_script.GetPropertyAt(2), m_guaranteedDoubleActionImage),
            };
        }
    }
}

#endif
