#  <#Title#>

Tela Compras

Tela que lista todas as compras feitas pelo usuário.

[ √ ] - Navigation: UINavigationController
[ √ ] - Controllers: UITableViewController 
[ √ ] - UINavigationItem > UIBarButtonItem:  que, ao ser tocado, abrirá a tela de cadastro do produto. 
[ √ ] - Caso a lista de produtos esteja vazia, mostrar a mensagem “Sua lista está vazia!” na tableview. 
[ √ ] - Os produtos devem ser salvos no Core Data (entidade Product), com relacionamentos com seus respectivos Estados (entidade State). 
[ √ ] - Quando houverem produtos, esta tela deverá mostrar a foto, nome e preço (em dólares) de cada produto.

Tela Produto

Tela onde o usuário irá cadastrar cada produto adquirido, informando:
[ √ ] - nome
[ √ ] - foto
[ √ ] - estado da compra
[ √ ] - valor em dólares
[ √ ] - compra foi feita com cartão ou não

Esta mesma tela servirá para que o produto selecionado na tela de Compras possa ser editado/alterado. 
Todos os campos são obrigatórios.

- Ao clicar na imagem de presente, o usuário poderá escolher se deseja inserir a foto do produto através da Biblioteca de fotos ou da Câmera, só mostrando câmera caso ela exista no device.
- Clicando no botão +, o usuário será levado para a tela de Ajustes, onde poderá cadastrar os Estados que serão selecionados pelo UITextField “Estado da compra”.
- A seleção do Estado da compra será feita através de UIPickerView.
