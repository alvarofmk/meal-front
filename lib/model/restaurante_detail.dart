class RestauranteDetailResult {
  String? id;
  String? nombre;
  String? descripcion;
  String? coverImgUrl;
  String? apertura;
  String? cierre;

  RestauranteDetailResult(
      {this.id,
      this.nombre,
      this.descripcion,
      this.coverImgUrl,
      this.apertura,
      this.cierre});

  RestauranteDetailResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    descripcion = json['descripcion'];
    coverImgUrl = json['coverImgUrl'];
    apertura = json['apertura'];
    cierre = json['cierre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    data['descripcion'] = this.descripcion;
    data['coverImgUrl'] = this.coverImgUrl;
    data['apertura'] = this.apertura;
    data['cierre'] = this.cierre;
    return data;
  }
}
