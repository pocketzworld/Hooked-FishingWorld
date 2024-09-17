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
    [AddComponentMenu("Lua/DrawerUI")]
    [LuaRegisterType(0xe51fdefd88b6dda2, typeof(LuaBehaviour))]
    public class DrawerUI : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "9dc4cd6505b844443af1db68ce0db8dd";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public UnityEngine.Texture m_image1 = default;
        [SerializeField] public UnityEngine.Texture m_image2 = default;
        [SerializeField] public UnityEngine.Texture m_image3 = default;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_image1),
                CreateSerializedProperty(_script.GetPropertyAt(1), m_image2),
                CreateSerializedProperty(_script.GetPropertyAt(2), m_image3),
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
