//
//  pal_cms.c
//  OpenSSL-Swift
//
//  Created by 𝗠𝗮𝗿𝘁𝗶𝗻 𝗟𝗮𝘂 on 2025-06-24.
//

#include "pal_cms.h"


int cc_sk_CMS_SignerInfo_num(CMS_ContentInfo * cms) {
    STACK_OF(X509) *signers = NULL;
    STACK_OF(CMS_SignerInfo) *sinfos;
    CMS_SignerInfo *si;
    
    int i;
    sinfos = CMS_get0_SignerInfos(cms);
    for (i = 0; i < sk_CMS_SignerInfo_num(sinfos); i++)
    {
        si = sk_CMS_SignerInfo_value(sinfos, i);
        
//        if (si->signer)
//        {
//            if (!signers)
//            {
//                signers = sk_X509_new_null();
//                if (!signers)
//                    return NULL;
//            }
//            if (!sk_X509_push(signers, si->signer))
//            {
//                sk_X509_free(signers);
//                return NULL;
//            }
//        }
    }
//    return signers;
    
//    int num =  sk_CMS_SignerInfo_num(signerInfo);
    return 0;
}
