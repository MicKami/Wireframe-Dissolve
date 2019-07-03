using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ShaderPropertySetter : MonoBehaviour
{
    public Transform position;
    private int position_propID;

    private void Update()
    {
        Shader.SetGlobalVector(position_propID, position.position);
    }

    private void OnValidate()
    {
        position_propID = Shader.PropertyToID("_MaskPosition");
    }
}
