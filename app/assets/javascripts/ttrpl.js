Game = function() {
  this.pickedRouteIds = [];
  this.allRoutes = [
    { id: 0, from: "Białystok", to: "Suwałki" },
    { id: 1, from: "Białystok", to: "Гродна" },
    { id: 2, from: "Bydgoszcz", to: "Toruń" },
    { id: 3, from: "Częstochowa", to: "Kielce" },
    { id: 4, from: "Częstochowa", to: "Kraków" },
    { id: 5, from: "Częstochowa", to: "Sosnowiec" },
    { id: 6, from: "Działdowo", to: "Warszawa" },
    { id: 7, from: "Elbląg", to: "Grudziądz" },
    { id: 8, from: "Elbląg", to: "Iława" },
    { id: 9, from: "Elbląg", to: "Olsztyn" },
    { id: 10, from: "Ełk", to: "Białystok" },
    { id: 11, from: "Gdańsk", to: "Elbląg" },
    { id: 12, from: "Gdańsk", to: "Laskowice" },
    { id: 13, from: "Gdynia", to: "Gdańsk" },
    { id: 14, from: "Gorzów Wlkp.", to: "Krzyż" },
    { id: 15, from: "Gorzów Wlkp.", to: "Poznań" },
    { id: 16, from: "Gorzów Wlkp.", to: "Zielona Góra" },
    { id: 17, from: "Grudziądz", to: "Laskowice" },
    { id: 18, from: "Grudziądz", to: "Toruń" },
    { id: 19, from: "Iława", to: "Działdowo" },
    { id: 20, from: "Iława", to: "Toruń" },
    { id: 21, from: "Inowrocław", to: "Bydgoszcz" },
    { id: 22, from: "Inowrocław", to: "Kutno" },
    { id: 23, from: "Inowrocław", to: "Toruń" },
    { id: 24, from: "Jelenia Góra", to: "Wrocław" },
    { id: 25, from: "Kalisz", to: "Łódź" },
    { id: 26, from: "Katowice", to: "Sosnowiec" },
    { id: 27, from: "Kielce", to: "Kraków" },
    { id: 28, from: "Kielce", to: "Radom" },
    { id: 29, from: "Kielce", to: "Rzeszów" },
    { id: 30, from: "Kielce", to: "Rzeszów" },
    { id: 31, from: "Koszalin", to: "Słupsk" },
    { id: 32, from: "Kraków", to: "Rzeszów" },
    { id: 33, from: "Kraków", to: "Warszawa" },
    { id: 34, from: "Krzyż", to: "Piła" },
    { id: 35, from: "Krzyż", to: "Poznań" },
    { id: 36, from: "Kutno", to: "Łódź" },
    { id: 37, from: "Kutno", to: "Płock" },
    { id: 38, from: "Kutno", to: "Warszawa" },
    { id: 39, from: "Laskowice", to: "Bydgoszcz" },
    { id: 40, from: "Leszno", to: "Poznań" },
    { id: 41, from: "Łódź", to: "Warszawa" },
    { id: 42, from: "Olsztyn", to: "Działdowo" },
    { id: 43, from: "Olsztyn", to: "Ełk" },
    { id: 44, from: "Olsztyn", to: "Iława" },
    { id: 45, from: "Opole", to: "Zabrze" },
    { id: 46, from: "Opole", to: "Częstochowa" },
    { id: 47, from: "Piła", to: "Bydgoszcz" },
    { id: 48, from: "Piła", to: "Koszalin" },
    { id: 49, from: "Piła", to: "Poznań" },
    { id: 50, from: "Poznań", to: "Inowrocław" },
    { id: 51, from: "Poznań", to: "Kalisz" },
    { id: 52, from: "Poznań", to: "Kutno" },
    { id: 53, from: "Praha", to: "Katowice" },
    { id: 54, from: "Praha", to: "Wrocław" },
    { id: 55, from: "Przemyśl", to: "Lublin" },
    { id: 56, from: "Przemyśl", to: "Львів" },
    { id: 57, from: "Radom", to: "Lublin" },
    { id: 58, from: "Rzeszów", to: "Lublin" },
    { id: 59, from: "Rzeszów", to: "Przemyśl" },
    { id: 60, from: "Słupsk", to: "Gdynia" },
    { id: 61, from: "Szczecin", to: "Gorzów Wlkp." },
    { id: 62, from: "Szczecin", to: "Koszalin" },
    { id: 63, from: "Szczecin", to: "Krzyż" },
    { id: 64, from: "Szczecin", to: "Zielona Góra" },
    { id: 65, from: "Świnoujście", to: "Szczecin" },
    { id: 66, from: "Toruń", to: "Kutno" },
    { id: 67, from: "Toruń", to: "Płock" },
    { id: 68, from: "Warszawa", to: "Białystok" },
    { id: 69, from: "Warszawa", to: "Lublin" },
    { id: 70, from: "Warszawa", to: "Radom" },
    { id: 71, from: "Wrocław", to: "Kalisz" },
    { id: 72, from: "Wrocław", to: "Leszno" },
    { id: 73, from: "Wrocław", to: "Opole" },
    { id: 74, from: "Zabrze", to: "Katowice" },
    { id: 75, from: "Zakopane", to: "Kraków" },
    { id: 76, from: "Zielona Góra", to: "Poznań" },
    { id: 77, from: "Zielona Góra", to: "Wrocław" },
    { id: 78, from: "Гродна", to: "Vilnius" },
    { id: 79, from: "Berlin", to: "Szczecin" },
    { id: 80, from: "Berlin", to: "Zielona Góra" }
  ];
};

Game.prototype.pickRoute = function() {
  var route;
  while (
    this.pickedRouteIds.indexOf(
      (route = this.allRoutes[
        Math.floor(Math.random() * this.allRoutes.length)
      ]).id
    ) !== -1
  );

  this.pickedRouteIds.push(route.id);

  if (this.pickedRouteIds.length === this.allRoutes.length) {
    this.pickedRouteIds = [];
  }

  return route;
};

window.game = new Game();

document.addEventListener("DOMContentLoaded", function(event) {
  document
    .getElementById("pick-route-btn")
    .addEventListener("click", function(event) {
      var route = game.pickRoute();
      from = route.from;
      to = route.to;
      document.getElementById("route").innerHTML = from + " — " + to;
    });
});
