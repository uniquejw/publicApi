<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
<script language="javascript">

	/*
    1. controller 호출 후 반환된 jsp
    2. 페이지, size, 키워드, 버튼
    3. 버튼 클릭하면 getAddrLocTrigger 함수 호출
    4. 받아온 데이터 makeList로 그리고 전체 데이터를 버튼으로 이동할 수 있도록 pageCount로 그리기
    5. 리스트 중 하나 클릭하면 해당 주소 지도가 바로 뜬다.
    6. 페이지 버튼을 누르면 폼에 값을 입력하는 로직을 거쳐 해당 목록을 가지고 온다.
     */
function getAddrLocTrigger() {
	let cP = 1;
	let cPP = $("#form").children().eq(1).val();
	getAddrLoc(cP, cPP)
}
	// 주소를 얻어오는 함수
function getAddrLoc(cP, cPP){
	// 적용예 (api 호출 전에 검색어 체크)
	if (!checkSearchedWord(document.form.keyword)) {
		return ;
	}
	$.ajax({
		 url :"https://business.juso.go.kr/addrlink/addrLinkApi.do"
		,type:"post"
		,data: {
			 currentPage : cP,
			 countPerPage : cPP,
			 resultType : $("#form").children().eq(2).val(),
			 confmKey : $("#form").children().eq(3).val(),
			 keyword : $("#form").children().eq(4).val()
				}
		,dataType:"json"
		,success:function(jsonStr){
			$("#list").html("");
			var errCode = jsonStr.results.common.errorCode;
			var errDesc = jsonStr.results.common.errorMessage;
			if(errCode != "0"){
				alert(errCode+"="+errDesc);
			}else{
				if(jsonStr != null){
					makeListJson(jsonStr);
					pageCount(cP, cPP, jsonStr.results.common.totalCount);

				}
			}
		}
	    ,error: function(xhr,status, error){
	    	alert("에러발생");
	    }
	});
}
	// 받은 주소List를 Json 형태로 만드는 함수
function makeListJson(jsonStr){
	var htmlStr = "";
	htmlStr += "<table class=\"table\">";
	console.log(jsonStr.results);
	$(jsonStr.results.juso).each(function(){
		htmlStr += "<tr>";
		htmlStr += "<td onClick=\"selectAddr(this)\">"+this.roadAddrPart1+"</td>";
		htmlStr += "</tr>";
	});
	htmlStr += "</table>";
	$("#list").html(htmlStr);
}

//특수문자, 특정문자열(sql예약어의 앞뒤공백포함) 제거
function checkSearchedWord(obj){
	if(obj.value.length >0){
		//특수문자 제거
		var expText = /[%=><]/ ;
		if(expText.test(obj.value) == true){
			alert("특수문자를 입력 할수 없습니다.") ;
			obj.value = obj.value.split(expText).join("");
			return false;
		}

		//특정문자열(sql예약어의 앞뒤공백포함) 제거
		var sqlArray = new Array(
			//sql 예약어
			"OR", "SELECT", "INSERT", "DELETE", "UPDATE", "CREATE", "DROP", "EXEC",
             		 "UNION",  "FETCH", "DECLARE", "TRUNCATE"
		);

		var regex;
		for(var i=0; i<sqlArray.length; i++){
			regex = new RegExp( sqlArray[i] ,"gi") ;

			if (regex.test(obj.value) ) {
			    alert("\"" + sqlArray[i]+"\"와(과) 같은 특정문자로 검색할 수 없습니다.");
				obj.value =obj.value.replace(regex, "");
				return false;
			}
		}
	}
	return true ;
}

function enterSearch() {
	var evt_code = (window.netscape) ? ev.which : event.keyCode;
	if (evt_code == 13) {
		event.keyCode = 0;
		getAddrLocTrigger();
	}
}

// 세부 주소를 클릭하면 주소 정보가 지도 검색 Input 창에 추가된다
function selectAddr(self){
	let len = $(self).text().split(" ").length;
	let str = "";
	for (let i = 0; i < len; i++) {
		str += " " + $(self).text().split(" ")[i]
	}
	KakaoMap(str);
}
</script>


<title>Insert title here</title>
</head>
<body>
	<nav class="navbar navbar-expand-lg bg-light">
		<div class="container-fluid">
			<a class="navbar-brand" href="#">Navbar</a>
			<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav me-auto mb-2 mb-lg-0">
					<li class="nav-item">
						<a class="nav-link active" aria-current="page" href="#">Home</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="#">Link</a>
					</li>
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
							Dropdown
						</a>
						<ul class="dropdown-menu">
							<li><a class="dropdown-item" href="#">Action</a></li>
							<li><a class="dropdown-item" href="#">Another action</a></li>
							<li><hr class="dropdown-divider"></li>
							<li><a class="dropdown-item" href="#">Something else here</a></li>
						</ul>
					</li>
					<li class="nav-item">
						<a class="nav-link disabled">Disabled</a>
					</li>
				</ul>
				<form class="d-flex" role="search">
					<input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
					<button class="btn btn-outline-success" type="submit">Search</button>
				</form>
			</div>
		</div>
	</nav>
	<div class="row">
			<div class="col" style="background: grey; height: 100vh; max-width: 12vw">
				<ul class="list-group list-group-flush">
					<li class="list-group-item">An item</li>
					<li class="list-group-item">A second item</li>
					<li class="list-group-item">A third item</li>
					<li class="list-group-item">A fourth item</li>
					<li class="list-group-item">And a fifth one</li>
				</ul>
			</div>
			<div class="col" style="padding: 5em; max-width: 30vw">
				<h3 class="card-title">주소 입력창</h3>
				<form name="form" id="form"method="post">
					<input class="d-none" type="text" name="currentPage" value="1"/> <!-- 요청 변수 설정 (현재 페이지. currentPage : n > 0) -->
					<input class="d-none" type="text" name="countPerPage" value="10"/><!-- 요청 변수 설정 (페이지당 출력 개수. countPerPage 범위 : 0 < n <= 100) -->
					<input class="d-none" type="text" name="resultType" value="json"/> <!-- 요청 변수 설정 (검색결과형식 설정, json) -->
					<input class="d-none" type="text" name="confmKey" id="confmKey" style="width:250px;display:none" value="devU01TX0FVVEgyMDIzMDIwMTE0MDk1MTExMzQ2NzE="/><!-- 요청 변수 설정 (승인키) -->
					<input type="text" name="keyword" value="수원" onkeydown="enterSearch();"/><!-- 요청 변수 설정 (키워드) -->
					<input type="button" onClick="getAddrLocTrigger();" value="주소검색하기"/>
					<div id="list" ></div><!-- 검색 결과 리스트 출력 영역 -->
				</form>
				<div class="row" style="max-width: 30vw">
					<div class="col" aria-label="Page navigation example">
						<ul class="pagination" id="pageBtn">

						</ul>
					</div>
				</div>
			</div>
			<div class="col" style="padding: 5em">
				<h3 class="card-title">지도</h3>
				<div id="map" style="height: 40vh; width: 40vw;"></div>
			</div>
		</div>
	</div>
</body>
</html>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=38930afdea1a5a245463ecacd811a6b7&libraries=services"></script>
<script>
	function KakaoMap(str) {
		console.log(str);
		let keyword = str

		var infowindow = new kakao.maps.InfoWindow({zIndex: 1});

		var mapContainer = document.getElementById('map'), // 지도를 표시할 div
				mapOption = {
					center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
					level : 3 // 지도의 확대 레벨
				};

		// 지도를 생성합니다
		var map = new kakao.maps.Map(mapContainer, mapOption);

		// 장소 검색 객체를 생성합니다
		var ps = new kakao.maps.services.Places();

		// 키워드로 장소를 검색합니다
		ps.keywordSearch(keyword, placesSearchCB);

		// 키워드 검색 완료 시 호출되는 콜백함수 입니다
		function placesSearchCB(data, status, pagination) {
			if (status === kakao.maps.services.Status.OK) {

				// 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
				// LatLngBounds 객체에 좌표를 추가합니다
				var bounds = new kakao.maps.LatLngBounds();

				for (var i = 0; i < data.length; i++) {
					displayMarker(data[i]);
					bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));
				}

				// 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
				map.setBounds(bounds);
			}
		}

		// 지도에 마커를 표시하는 함수입니다
		function displayMarker(place) {

			// 마커를 생성하고 지도에 표시합니다
			var marker = new kakao.maps.Marker({
				map     : map,
				position: new kakao.maps.LatLng(place.y, place.x)
			});

			// 마커에 클릭이벤트를 등록합니다
			kakao.maps.event.addListener(marker, 'click', function () {
				// 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
				infowindow.setContent('<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>');
				infowindow.open(map, marker);
			});
		}
	}
</script>
<script>

//pageCount 진행
function pageCount(cP, s, totalcount){
	console.log("pageCount 들어왔어?")
	let innerHTML2 = ""
	/*
	currentPage = 배열 기준으로 잡기 위해 -1 진행
	sizing = 기준 사이즈
	totalCount = 목록 전체 갯수
	pageCount = 페이지 전체 갯수
	start = 해당 목록의 시작 번호
	end = 해당 목록의 끝 번호
	previous = 이전 목록으로 가기
	next = 다음 목록으로 가기

	*/
	let currentPage = Number(cP)-1
	let sizing = Number(s);
	let totalCount = Number(totalcount);
	let pageCount = totalCount%sizing != 0 ? Math.round(totalCount/sizing) : Math.trunc(totalCount/sizing);
	let start = parseInt(currentPage/sizing)*sizing;
	let end = start + sizing <= pageCount ? start + sizing : pageCount;
	let previ = Number(start)-1
	let previous = start <= 0 ? "" : `<li class="page-item"><a class="page-link" onClick="clickPageBtn(this.id)" id="btn`+previ+`">Previous</a></li>`;
	let next = end >= pageCount ? "" : `<li class="page-item"><a class="page-link" onClick="clickPageBtn(this.id)" id="btn`+end+`">Next</a></li>`;
	innerHTML2 += previous;
	for(let i = start; i < end; i++){
		let pageBtn = Number(i)+1;
		innerHTML2 += `<li class="page-item"><a class="page-link" onClick="clickPageBtn(this.id)" id="btn`+ i +`">`+ pageBtn +`</a></li>`
	}
	innerHTML2 += next;
	document.querySelector("#pageBtn").innerHTML = innerHTML2;
	for(let i = 0; i<document.getElementById("pageBtn").childElementCount; i++){
		document.getElementById("pageBtn").children[i].children[0].classList.remove("active")
	}
	document.getElementById(`btn`+currentPage).classList.add("active");
}

function clickPageBtn(id){
console.log(id);
let sizing = 10;
let selectPage = Number(id.substr(3))+1;
	$("#form").children().eq(0).val(selectPage);
		getAddrLoc(Number(selectPage), Number(sizing));
	}
</script>