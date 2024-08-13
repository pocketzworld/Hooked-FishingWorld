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
    [AddComponentMenu("Lua/FirstPersonCamera")]
    [LuaBehaviourScript(s_scriptGUID)]
    public class FirstPersonCamera : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "c09406aec98e45e4dbd229bb77b59aa6";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public System.Double m_cameraHeightFromPlayer = 1.5;
        [SerializeField] public System.Boolean m_EnableMaxPitch = true;
        [SerializeField] public System.Boolean m_EnableMaxYaw = false;
        [SerializeField] public System.Double m_minPitch = -45;
        [SerializeField] public System.Double m_maxPitch = 45;
        [SerializeField] public System.Double m_minYaw = -360;
        [SerializeField] public System.Double m_maxYaw = 360;
        [SerializeField] public System.Double m_touchRotationSensitivity = 0.4;
        [SerializeField] public System.Double m_mouseRotationSensitivity = 0.25;
        [SerializeField] public System.Double m_rotationSmoothing = 1;
        [SerializeField] public System.Double m_FOV = 70;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_cameraHeightFromPlayer),
                CreateSerializedProperty(_script.GetPropertyAt(1), m_EnableMaxPitch),
                CreateSerializedProperty(_script.GetPropertyAt(2), m_EnableMaxYaw),
                CreateSerializedProperty(_script.GetPropertyAt(3), m_minPitch),
                CreateSerializedProperty(_script.GetPropertyAt(4), m_maxPitch),
                CreateSerializedProperty(_script.GetPropertyAt(5), m_minYaw),
                CreateSerializedProperty(_script.GetPropertyAt(6), m_maxYaw),
                CreateSerializedProperty(_script.GetPropertyAt(7), m_touchRotationSensitivity),
                CreateSerializedProperty(_script.GetPropertyAt(8), m_mouseRotationSensitivity),
                CreateSerializedProperty(_script.GetPropertyAt(9), m_rotationSmoothing),
                CreateSerializedProperty(_script.GetPropertyAt(10), m_FOV),
            };
        }
    }
}

#endif
