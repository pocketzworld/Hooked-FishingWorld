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
    [AddComponentMenu("Lua/LevelSelectCamera")]
    [LuaRegisterType(0x5bc8b37bab814b3e, typeof(LuaBehaviour))]
    public class LevelSelectCamera : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "a65a0ab44ea0b7043acf55e555e3d021";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public UnityEngine.GameObject m_rewardPopup = default;
        [SerializeField] public UnityEngine.Texture m_lockedImage = default;
        [SerializeField] public UnityEngine.Transform m_playerCamera = default;
        [SerializeField] public System.Double m_padding = 1;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_rewardPopup),
                CreateSerializedProperty(_script.GetPropertyAt(1), m_lockedImage),
                CreateSerializedProperty(_script.GetPropertyAt(2), m_playerCamera),
                CreateSerializedProperty(_script.GetPropertyAt(3), m_padding),
            };
        }
    }
}

#endif
