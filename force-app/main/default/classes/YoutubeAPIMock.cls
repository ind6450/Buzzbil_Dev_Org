/**
 * Created by MZC01-JEREMIAH on 2023-01-13.
 */

public with sharing class YoutubeAPIMock implements HttpCalloutMock {

    public HttpResponse respond(HttpRequest req) {

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('{\n' +
                '    "kind": "youtube#searchListResponse",\n' +
                '    "etag": "5KP_qx5IeglAcXoZokH3I6UId9M",\n' +
                '    "regionCode": "KR",\n' +
                '    "pageInfo": {\n' +
                '        "totalResults": 5,\n' +
                '        "resultsPerPage": 4\n' +
                '    },\n' +
                '    "items": [\n' +
                '        {\n' +
                '            "kind": "youtube#searchResult",\n' +
                '            "etag": "CzoRA805zKQc95WCO0pV6r2kYtY",\n' +
                '            "id": {\n' +
                '                "kind": "youtube#video",\n' +
                '                "videoId": "JAHYIyRScVk"\n' +
                '            },\n' +
                '            "snippet": {\n' +
                '                "publishedAt": "2021-03-14T11:41:03Z",\n' +
                '                "channelId": "UCxGyH7vzYkZwFseTUa3yZpQ",\n' +
                '                "title": "\uD83C\uDF38 나랑 벚꽃 보러 갈래? 봄 향기 가득한 봄 노래 모음 | P͏L͏A͏Y͏L͏I͏S͏T͏",\n' +
                '                "description": "봄 향기 가득한 봄 감성 플레이리스트 영상이 마음에 드셨다면 [ 구독 ❤️️ ] [ 좋아요 ] [ 알림 ] - 수익 창출을 하지 않는 채널 ...",\n' +
                '                "thumbnails": {\n' +
                '                    "default": {\n' +
                '                        "url": "https://i.ytimg.com/vi/JAHYIyRScVk/default.jpg",\n' +
                '                        "width": 120,\n' +
                '                        "height": 90\n' +
                '                    },\n' +
                '                    "medium": {\n' +
                '                        "url": "https://i.ytimg.com/vi/JAHYIyRScVk/mqdefault.jpg",\n' +
                '                        "width": 320,\n' +
                '                        "height": 180\n' +
                '                    },\n' +
                '                    "high": {\n' +
                '                        "url": "https://i.ytimg.com/vi/JAHYIyRScVk/hqdefault.jpg",\n' +
                '                        "width": 480,\n' +
                '                        "height": 360\n' +
                '                    }\n' +
                '                },\n' +
                '                "channelTitle": "찐막 JJINMAK",\n' +
                '                "liveBroadcastContent": "none",\n' +
                '                "publishTime": "2021-03-14T11:41:03Z"\n' +
                '            }\n' +
                '        },\n' +
                '        {\n' +
                '            "kind": "youtube#searchResult",\n' +
                '            "etag": "OPMahhk86ZpNvxpE77ALLOnX8qU",\n' +
                '            "id": {\n' +
                '                "kind": "youtube#video",\n' +
                '                "videoId": "8SpisA5vW5s"\n' +
                '            },\n' +
                '            "snippet": {\n' +
                '                "publishedAt": "2021-03-19T12:00:03Z",\n' +
                '                "channelId": "UC_gkwRB-p1JrOzzJk7PBKDQ",\n' +
                '                "title": "벚꽃 보러 갈래?\uD83C\uDF38 봄 외출 룩북| 개강룩 오피스룩 하객룩 출근룩 직장인룩 데이트룩 | casual spring outfits",\n' +
                '                "description": "룩북 #봄외출룩 #데이트룩 #봄하객룩 #봄오피스룩 #봄옷추천 안녕하세요 :) 소신사장입니다. 이젠 안 속으시죠..? 최근에 찐한친구 ...",\n' +
                '                "thumbnails": {\n' +
                '                    "default": {\n' +
                '                        "url": "https://i.ytimg.com/vi/8SpisA5vW5s/default.jpg",\n' +
                '                        "width": 120,\n' +
                '                        "height": 90\n' +
                '                    },\n' +
                '                    "medium": {\n' +
                '                        "url": "https://i.ytimg.com/vi/8SpisA5vW5s/mqdefault.jpg",\n' +
                '                        "width": 320,\n' +
                '                        "height": 180\n' +
                '                    },\n' +
                '                    "high": {\n' +
                '                        "url": "https://i.ytimg.com/vi/8SpisA5vW5s/hqdefault.jpg",\n' +
                '                        "width": 480,\n' +
                '                        "height": 360\n' +
                '                    }\n' +
                '                },\n' +
                '                "channelTitle": "소신사장 SoshinTV",\n' +
                '                "liveBroadcastContent": "none",\n' +
                '                "publishTime": "2021-03-19T12:00:03Z"\n' +
                '            }\n' +
                '        },\n' +
                '        {\n' +
                '            "kind": "youtube#searchResult",\n' +
                '            "etag": "1JKD70I7eEXgZa4uWiKR0c4snIM",\n' +
                '            "id": {\n' +
                '                "kind": "youtube#video",\n' +
                '                "videoId": "lMqIYbwRj0o"\n' +
                '            },\n' +
                '            "snippet": {\n' +
                '                "publishedAt": "2021-03-19T08:00:19Z",\n' +
                '                "channelId": "UCBhqQ7ueo_l-a1XaeuL-GHw",\n' +
                '                "title": "EVENT\uD83D\uDC95요즘 대세 힙한 애슬레저룩 코디 룩북 | 운동하는 간호사 추천 코디 모음(헬스,런닝,요가,등산,필라테스 코디) Sportswear Outfits Lookbook(ENG)",\n' +
                '                "description": "단색 #룩북 #자유브라 #컴포트에어 요즘 대세 ! 운동하는 여자들을 위한 애슬레저룩 코디 룩북 (ENG SUB) 확 따뜻해진 봄날씨와 함께 ...",\n' +
                '                "thumbnails": {\n' +
                '                    "default": {\n' +
                '                        "url": "https://i.ytimg.com/vi/lMqIYbwRj0o/default.jpg",\n' +
                '                        "width": 120,\n' +
                '                        "height": 90\n' +
                '                    },\n' +
                '                    "medium": {\n' +
                '                        "url": "https://i.ytimg.com/vi/lMqIYbwRj0o/mqdefault.jpg",\n' +
                '                        "width": 320,\n' +
                '                        "height": 180\n' +
                '                    },\n' +
                '                    "high": {\n' +
                '                        "url": "https://i.ytimg.com/vi/lMqIYbwRj0o/hqdefault.jpg",\n' +
                '                        "width": 480,\n' +
                '                        "height": 360\n' +
                '                    }\n' +
                '                },\n' +
                '                "channelTitle": "Dansaek 단색",\n' +
                '                "liveBroadcastContent": "none",\n' +
                '                "publishTime": "2021-03-19T08:00:19Z"\n' +
                '            }\n' +
                '        },\n' +
                '        {\n' +
                '            "kind": "youtube#searchResult",\n' +
                '            "etag": "uWN-b68yLaxUzP6nvHQyzBccP80",\n' +
                '            "id": {\n' +
                '                "kind": "youtube#video",\n' +
                '                "videoId": "7MzP1TUdR6M"\n' +
                '            },\n' +
                '            "snippet": {\n' +
                '                "publishedAt": "2022-04-08T09:00:04Z",\n' +
                '                "channelId": "UCtdkkbBWwveQNHHo8WYh8JQ",\n' +
                '                "title": "벚꽃 보러갈래요?#Shorts",\n' +
                '                "description": "1415 - naps! (feat. 원필 (DAY6))",\n' +
                '                "thumbnails": {\n' +
                '                    "default": {\n' +
                '                        "url": "https://i.ytimg.com/vi/7MzP1TUdR6M/default.jpg",\n' +
                '                        "width": 120,\n' +
                '                        "height": 90\n' +
                '                    },\n' +
                '                    "medium": {\n' +
                '                        "url": "https://i.ytimg.com/vi/7MzP1TUdR6M/mqdefault.jpg",\n' +
                '                        "width": 320,\n' +
                '                        "height": 180\n' +
                '                    },\n' +
                '                    "high": {\n' +
                '                        "url": "https://i.ytimg.com/vi/7MzP1TUdR6M/hqdefault.jpg",\n' +
                '                        "width": 480,\n' +
                '                        "height": 360\n' +
                '                    }\n' +
                '                },\n' +
                '                "channelTitle": "우주음악 주식회사",\n' +
                '                "liveBroadcastContent": "none",\n' +
                '                "publishTime": "2022-04-08T09:00:04Z"\n' +
                '            }\n' +
                '        }\n' +
                '    ]\n' +
                '}');

        return res;
    }
}