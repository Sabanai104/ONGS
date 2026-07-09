struct OngDetailResponse: Decodable {
    let id: String
    let titulo: String
    let imagem: String
    let descricao: String
    let comoAjudar: String
    let impactosRealizados: String
    let localizacao: OngDetailLocation
    let linkSite: String?
    let linkInstagram: String?
    let categorias: [String]
}

struct OngDetailLocation: Decodable {
    let latitude: Double
    let longitude: Double
    let nomeEndereco: String
}
