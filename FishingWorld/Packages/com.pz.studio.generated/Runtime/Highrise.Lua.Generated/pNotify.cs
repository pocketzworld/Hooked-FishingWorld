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

namespace Highrise.Lua.Generated
{
    [AddComponentMenu("Lua/pNotify")]
    [LuaBehaviourScript(s_scriptGUID)]
    public class pNotify : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "03ee68479d87cd8439d57b77ca30a251";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public Highrise.AudioShader m_alertSound = default;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_alertSound),
            };
        }
    }
}

#endif