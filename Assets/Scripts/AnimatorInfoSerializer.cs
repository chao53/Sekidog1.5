//using System.Collections;
//using System.Collections.Generic;
//using UnityEngine;
//using Mirror;

//namespace Sekidog
//{
//    public static class AnimatorInfoSerializer
//    {
//        public static void WriteAnimatorInfo(this NetworkWriter writer, AnimatorInfo animatorInfo)
//        {
//            writer.WriteFloat(animatorInfo.Ix);
//            writer.WriteFloat(animatorInfo.Iz);
//        }

//        public static AnimatorInfo ReadAnimatorInfo(this NetworkReader reader)
//        {
//            return new AnimatorInfo
//            {
//                Ix = reader.ReadFloat(),
//                Iz = reader.ReadFloat()
//            };
//        }
//    }
//}

