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
    [AddComponentMenu("Lua/AudioManager")]
    [LuaBehaviourScript(s_scriptGUID)]
    public class AudioManager : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "8f64230ed94678b4a93d9ee72a289fc1";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public Highrise.AudioShader m_BGMusic = default;
        [SerializeField] public Highrise.AudioShader m_paperSoundEffect1 = default;
        [SerializeField] public Highrise.AudioShader m_rewardSoundEffect1 = default;
        [SerializeField] public Highrise.AudioShader m_splashSoundEffect1 = default;
        [SerializeField] public Highrise.AudioShader m_coinsSoundEffect1 = default;
        [SerializeField] public Highrise.AudioShader m_coinsSoundEffect2 = default;
        [SerializeField] public Highrise.AudioShader m_equipSoundEffect = default;
        [SerializeField] public Highrise.AudioShader m_baitSoundEffect = default;
        [SerializeField] public Highrise.AudioShader m_errorSoundEffect = default;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_BGMusic),
                CreateSerializedProperty(_script.GetPropertyAt(1), m_paperSoundEffect1),
                CreateSerializedProperty(_script.GetPropertyAt(2), m_rewardSoundEffect1),
                CreateSerializedProperty(_script.GetPropertyAt(3), m_splashSoundEffect1),
                CreateSerializedProperty(_script.GetPropertyAt(4), m_coinsSoundEffect1),
                CreateSerializedProperty(_script.GetPropertyAt(5), m_coinsSoundEffect2),
                CreateSerializedProperty(_script.GetPropertyAt(6), m_equipSoundEffect),
                CreateSerializedProperty(_script.GetPropertyAt(7), m_baitSoundEffect),
                CreateSerializedProperty(_script.GetPropertyAt(8), m_errorSoundEffect),
            };
        }
    }
}

#endif
