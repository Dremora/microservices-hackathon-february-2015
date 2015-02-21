// Generated by LiveScript 1.3.1
(function(){
  var combo, clockElem, arenaElem;
  combo = new Combo("http://52.16.7.112:8000");
  combo.use(["state", "ArenaClock"]);
  combo.listen("state", function(data){});
  clockElem = document.getElementById("clock");
  combo.listen("ArenaClock", function(data){
    return clockElem.replaceChild(document.createTextNode(data.tick), clockElem.firstChild);
  });
  arenaElem = document.getElementById("arena");
  combo.listen("state", function(data){
    return arenaElem.textContent = JSON.stringify(data, null, "  ");
  });
}).call(this);
