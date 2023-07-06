/**
 * Created by MZC01-JIEUN on 2023-01-10.
 */

public with sharing class YoutubeAPI implements Queueable, Database.AllowsCallouts{

    private List<Opportunity> opportunities = new List<Opportunity>();

    public YoutubeAPI(List<Opportunity> opportunities) {

        this.opportunities = opportunities;

    }

    public static String[] parseJsonData(Map<String, Object> jsonMap, String youtubeUrl, String searchType) {

        String[] result = new String[2];
        result[0] = 'Youtube URL을 확인해 주세요';
        result[1] = '';

        List<String> splitStr = new List<String>();
        String flag = '';

        // Channel로 검색할 시 필요
//        if (searchType == 'video') {
            if (youtubeUrl.contains('v=')) {
                splitStr = youtubeUrl.split('=');
                flag = splitStr.get(splitStr.size() - 1);
            } else {
                splitStr = youtubeUrl.split('/');
                flag = splitStr.get(splitStr.size() - 1);
            }
//        }

        List<Object> items = (List<Object>) jsonMap.get('items');

        if (items.size() > 0) {

            Map<String, Object> itemMap = new Map<String, Object>();
            Map<String, Object> videoIds = new Map<String, Object>();
            Map<String, Object> snippetMap = new Map<String, Object>();

            if (flag != '') {
                for (Integer i = 0; i < items.size(); i++) {
                    itemMap = (Map<String, Object>) items.get(i);
                    videoIds = (Map<String, Object>) itemMap.get('id');
                    if (videoIds.get('videoId') == flag) snippetMap = (Map<String, Object>) itemMap.get('snippet');
                }
            } else {
                itemMap = (Map<String, Object>) items.get(0);
                snippetMap = (Map<String, Object>) itemMap.get('snippet');
            }


            if (snippetMap != null) {
                result[0] = (String) snippetMap.get('channelId');
                result[1] = (String) snippetMap.get('channelTitle');
            } else {
                return result;
            }
        }
        return result;

    }

    public void execute(QueueableContext qc) {

        String youtubeUrl = opportunities[0].Youtube_URL__c;

        if (youtubeUrl != null && youtubeUrl != '') {
            String part = 'snippet';
            String key = 'AIzaSyAtNEEqir8nMVM3eSuP2tUpLwdfsJA6IjQ';
            String searchType = '';
            String[] YoutubeDataArr = new String[2];

            Http http = new Http();
            HttpRequest req = new HttpRequest();
            String sendUrl = 'https://www.googleapis.com/youtube/v3/search?part=';

//            채널로 검색할시 필요(23/02/09 - HYUN)
//            if (youtubeUrl.contains('channel') || youtubeUrl.contains('@')) {
//                searchType = 'channel';
//            } else {
//                searchType = 'video';
//            }

            req.setEndpoint(sendUrl + part + '&q=' + EncodingUtil.urlEncode(youtubeUrl, 'UTF-8') + '&key=' + key + '&type=video');
            req.setMethod('GET');

            try {
                HttpResponse res = http.send(req);
                System.debug('STATUS:' + res.getStatus());
                System.debug('STATUS_CODE:' + res.getStatusCode());
                if (res.getStatus() == 'OK' && res.getStatusCode() == 200) {
                    Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    YoutubeDataArr = parseJsonData(jsonMap, youtubeUrl, searchType);
                }
            } catch (Exception e) {
                System.debug('Exception! : ' + e.getMessage());
                System.debug('Error Line Number :' + e.getLineNumber());
            }

            opportunities[0].Youtube_Channel_Id__c = YoutubeDataArr[0];
            opportunities[0].Youtube_Channel_Name__c = YoutubeDataArr[1];

        } else {
            opportunities[0].Youtube_Channel_Id__c = null;
            opportunities[0].Youtube_Channel_Name__c = null;
        }

        try{
            update opportunities;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

    }

}