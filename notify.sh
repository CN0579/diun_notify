#!/bin/sh


#电报参数
TG_CHAT_ID="-1001504060848"
TG_TOKEN="5461391235:AAEcvpERKWjV70CmY8qR2TUenrHUxQLgkUQ"

#企微参数
CORPID="ww0948ba3ef3e94994"
CORP_SECRET="dg5CYeOJtfWm2ZbDA2XUILHEFW5W15Ms8PKHUq9ZVX4"
AGENTID="1000004"
MEDIA_ID="2iwvAiDgHSmNOSNm_Hmq4QYn7sUTJ9zLNGjxZV5OK7zoNFvfyaujOkCpqaCBABWt-"
TOUSER="@all"

export DIUN_VERSION111=$DIUN_VERSION
export DIUN_ENTRY_STATUS111=$DIUN_ENTRY_STATUS
export DIUN_HOSTNAME111=$DIUN_HOSTNAME
export DIUN_ENTRY_PROVIDER111=$DIUN_ENTRY_PROVIDER
export DIUN_ENTRY_IMAGE111=$DIUN_ENTRY_IMAGE
export DIUN_ENTRY_HUBLINK111=$DIUN_ENTRY_HUBLINK
export DIUN_ENTRY_MIMETYPE111=$DIUN_ENTRY_MIMETYPE
export DIUN_ENTRY_DIGEST111=$DIUN_ENTRY_DIGEST
export DIUN_ENTRY_CREATED111=$DIUN_ENTRY_CREATED
export DIUN_ENTRY_PLATFORM111=$DIUN_ENTRY_PLATFORM

function qywx()
{
    RET=$(/data/tools/curl -s https://qyapi.weixin.qq.com/cgi-bin/gettoken?"corpid="${CORPID}"&corpsecret="${CORP_SECRET}"")
    KEY=$(echo ${RET} | /data/tools/jq -r .access_token)

    

    cat>tmp_qywx<<EOF
{
   "touser" : "${TOUSER}",
   "msgtype" : "news",
   "agentid" : "${AGENTID}",
   "news" : {
       "articles":[
           {
               "title": "DOCKER有更新啦~",
               "description": "容       器： ${DIUN_HOSTNAME111}\n镜       像： ${DIUN_ENTRY_IMAGE111}\n创建时间： ${DIUN_ENTRY_CREATED111}\n平       台： ${DIUN_ENTRY_PLATFORM111}\n",
               "picurl": "https://www.bing.com/th?id=OHR.ShadowEverest_EN-US0301475882_UHD.jpg&w=1000"
            }
       ]
   },
   "enable_id_trans": 0,
   "enable_duplicate_check": 0,
   "duplicate_check_interval": 1800
}
EOF

    /data/tools/curl -d @tmp_qywx -XPOST https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token="${KEY}"
}


function telegram()
{
    TG_URL='https://api.telegram.org/bot'${TG_TOKEN}'/sendMessage'
    cat>tmp_tg<<EOF
{
    "chat_id": "${TG_CHAT_ID}",
    "parse_mode":"Markdown",
    "text": "*DOCKER有更新啦~*\n\n*容         器：* ${DIUN_HOSTNAME111}\n*镜         像：* ${DIUN_ENTRY_IMAGE111}\n*创建时间：* ${DIUN_ENTRY_CREATED111}\n*平         台：* ${DIUN_ENTRY_PLATFORM111}\n"
}
EOF
    /data/tools/curl --location --request POST ${TG_URL} --header 'Content-Type: application/json' -d @tmp_tg

}


if [ ! -n "${TG_TOKEN}" ]; then
    echo "未配置电报参数或者配置不全，跳过通知！"
else
    telegram
fi

if [ ! -n "${CORP_SECRET}" ]; then
    echo "未配置企业微信参数或者配置不全，跳过通知！"
else
    qywx
fi