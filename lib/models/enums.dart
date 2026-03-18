enum Role {
  admin,        // pode acessar tudo
  seller,       // pode gerenciar pedidos e clientes
  customer,     // pode comprar
  manager,      // pode gerenciar funcionários, clientes, pedidos, produtos, mas não pode acessar configurações avançadas
  driver,       // pode gerenciar entregas
  warehouse,    // pode gerenciar produtos
}
