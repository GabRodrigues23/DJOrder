# DJOrder 🍔📊

**DJOrder** é um sistema de **KDS (Kitchen Display System)** e Monitoramento de Pedidos em tempo real. O projeto foi desenvolvido para integrar-se com o sistema DJMonitor/DJPDV via banco de dados Firebird, oferecendo uma interface moderna, reativa e focada na experiência do usuário para gerenciamento de comandas.

---

## 🚀 Funcionalidades

### 🖥️ Frontend (App)
* **Monitoramento em Tempo Real:** Atualização automática da grid de mesas/comandas.
* **SLA Visual (Service Level Agreement):**
  * Cronômetro individual em cada cartão de pedido.
  * Indicadores visuais (Ícone Amarelo/Vermelho) baseados no tempo de espera configurado.
* **Busca Inteligente:** Pesquisa rápida por **Número da Comanda** ou **Nome do Cliente**, com filtragem dinâmica.
* **Filtros de Status:** Visualização rápida de mesas Livres, Ocupadas ou Bloqueadas.
* **Notificações Sonoras:** Alerta de áudio ("Ding") quando novos pedidos entram na fila.
* **Configurações Persistentes:**
  * Alteração de URL da API.
  * Definição de tempos de alerta (Warning / Critical).
  * Controle de intervalo de atualização (Refresh Rate).
  * Toggle para ativar/desativar sons e cores de SLA.

### ⚙️ Backend (API)
* **API RESTful:** Desenvolvida em **Lazarus (Free Pascal)** utilizando o framework **Horse**.
* **Alta Performance:** Leve e rápido, rodando como aplicação de console.
* **Integração Firebird:** Leitura direta das tabelas `PREVENDA`, `PRE_ITEM` e `PRODUTO`.
* **Formatação ISO 8601:** Tratamento de datas compatível com Flutter.
* **Testes Unitários:** Testes automatizados para garantir o bom funcionamento.

---

## 🛠️ Tecnologias Utilizadas

### Mobile / Desktop (Flutter)
* **Linguagem:** Dart
* **Gerência de Estado / Injeção:** `flutter_modular`
* **Arquitetura:** MVVM (Model-View-ViewModel) + conceitos de Clean Architecture
* **HTTP Client:** `dio`
* **Persistência Local:** `shared_preferences`
* **Áudio:** `audioplayers`

### Server (Lazarus)
* **Linguagem:** Object Pascal (Free Pascal)
* **Framework:** Horse (Micro-framework para API)
* **Conexão DB:** ZeosLib (ZComponent)
* **Banco de Dados:** Firebird 2.5 / 3.0 / 5.0

---

## 📂 Estrutura do Projeto


## Backend
```bash
└── djorder_server/ 
    ├── src/
    │   ├── controllers/
    │   │   └── controller_orders.pas
    │   ├── routes/
    │   │   └── routes.pas
    │   └── services/
    │       └── connection.pas
    ├── djorder_server.exe 
    ├── djorder_server.lpi 
    └── djorder_server.lpr 



```

## Frontend
```bash
└── djorder
    ├── assets/
    │   ├── fonts/
    │   │   └── montserrat/
    │   └── sounds/
    │       └── alert.mp3
    ├── lib/
    │   ├── core/          
    │   │   ├── routes/
    │   │   │   ├── app_module.dart
    │   │   │   └── app_widget.dart
    │   │   └── utils/
    │   │       └── dto_utils.dart
    │   ├── features/      
    │   │   ├── dto/
    │   │   │   └── order_dto.dart
    │   │   ├── interfaces/
    │   │   │   └── order_repository_interface.dart
    │   │   ├── model/
    │   │   │   ├── order.dart
    │   │   │   ├── order_additional.dart
    │   │   │   └── order_items.dart
    │   │   ├── repository/
    │   │   │   └── order_repository.dart    
    │   │   ├── service/
    │   │   │   ├── order_service.dart
    │   │   │   └── settings_service.dart    
    │   │   ├── view/
    │   │   │   ├── home/   
    │   │   │   │   └── home_page.dart 
    │   │   │   ├── monitor/
    │   │   │   │   ├── widgets/
    │   │   │   │   │   └── widgets/
    │   │   │   │   │       ├── order_details_panel.dart
    │   │   │   │   │       ├── order_filters_bar.dart
    │   │   │   │   │       └── order_item_widget.dart
    │   │   │   │   └── orders_monitor_page.dart
    │   │   │   ├── settings/
    │   │   │   │   └── settings_page.dart
    │   │   │   └── module_routes.dart
    │   │   └── viewmodel/ 
    │   │       └── order_view_model.dart
    │   ├── shared/  
    │   │   ├── enums/
    │   │   │   └── order_status_type.dart
    │   │   └── extensions/
    │   │       ├── order_status_extension.dart
    │   │       └── order_theme_extensiond.dart
    │   └── main.dart
    ├── test/
    │   └── core/          
    │       ├── dto/
    │       │   └── order_dto_parsing_test.dart
    │       ├── extensions/
    │       │   └── order_status_test.dart
    │       ├── model/
    │       │   └── order_test.dart    
    │       └── viewmodel/
    │           └── order_view_model_test.dart
    ├── pubspec.yaml
    └── README.md

```
---

## 📦 Como Rodar o Projeto

### Pré-requisitos
* Flutter SDK instalado
* Lazarus IDE
* Banco de Dados Firebird ou `fbclient.dll` disponível

---

### 1️⃣ Backend (Servidor)

1. Abra o projeto:
   ```
   djorder_server/djorder_server.lpi
   ```
2. Compile o projeto (`Ctrl + F9`).
3. Garanta que o `fbclient.dll` e o banco de dados estejam acessíveis.
4. Execute o `djorder_server.exe`.

O servidor iniciará em modo console escutando na porta **9000**.

---

### 2️⃣ Frontend (Cliente)

1. Acesse a pasta do projeto Flutter:
   ```bash
   cd djorder
   ```
2. Instale as dependências:
   ```bash
   flutter pub get
   ```
3. Execute o projeto (Desktop ou Mobile):
   ```bash
   flutter run
   ```

4. No aplicativo, vá até **Configurações (⚙️)** e configure a URL da API:
   * Exemplo local:
     * `http://localhost:9000`
     * `http://192.168.x.x:9000`

---

## 📄 Licença

Este projeto é de uso **interno/corporativo** e não está disponível para distribuição pública.
