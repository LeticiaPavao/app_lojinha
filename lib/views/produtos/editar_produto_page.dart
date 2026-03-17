import 'package:flutter/material.dart';
import 'package:app_padrao/models/produto.dart';
import 'package:app_padrao/services/services/produto_service.dart';

class EditarProdutoPage extends StatefulWidget {
  final String produtoId;

  const EditarProdutoPage({super.key, required this.produtoId});

  @override
  State<EditarProdutoPage> createState() => _EditarProdutoPageState();
}

class _EditarProdutoPageState extends State<EditarProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _imagemUrlController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _estoqueController = TextEditingController();
  final _fornecedorController = TextEditingController();
  final _pesoController = TextEditingController();
  final _createdAt = TextEditingController();

  DateTime? _dataValidade;
  String _unidadeMedida = 'un';
  bool _isActive = true;

  final List<String> _unidades = ['un', 'kg', 'g', 'l', 'ml', 'cx'];

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  final produtoService = ProdutoService();

  @override
  void initState() {
    super.initState();
    _carregarProduto();
  }

  Future<void> _carregarProduto() async {
    try {
      final produto = await produtoService.getProduto(widget.produtoId);
      if (produto == null) {
        setState(() {
          _errorMessage = 'Produto não encontrado';
          _isLoading = false;
        });
        return;
      }

      _nomeController.text = produto.nome;
      _precoController.text = produto.preco.toString();
      _descricaoController.text = produto.descricao ?? '';
      _imagemUrlController.text = produto.imagemUrl ?? '';
      _categoriaController.text = produto.categoria;
      _estoqueController.text = produto.estoque.toString();
      _fornecedorController.text = produto.fornecedor;
      _pesoController.text = produto.peso?.toString() ?? '';
      _dataValidade = produto.dataValidade;
      _unidadeMedida = produto.unidadeMedida;
      _isActive = produto.isActive;
      _createdAt.text = produto.createdAt.toIso8601String();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar produto: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataValidade ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dataValidade = picked;
      });
    }
  }

  Future<void> _salvarProduto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final produto = Produto(
        id: widget.produtoId,
        nome: _nomeController.text,
        preco: double.parse(_precoController.text),
        descricao: _descricaoController.text.isEmpty
            ? null
            : _descricaoController.text,
        imagemUrl: _imagemUrlController.text.isEmpty
            ? null
            : _imagemUrlController.text,
        categoria: _categoriaController.text,
        estoque: int.parse(_estoqueController.text),
        dataValidade: _dataValidade,
        fornecedor: _fornecedorController.text,
        peso: _pesoController.text.isEmpty
            ? null
            : double.parse(_pesoController.text),
        unidadeMedida: _unidadeMedida,
        isActive: _isActive,
        createdAt: _createdAt.text.isEmpty
            ? DateTime.now()
            : DateTime.parse(_createdAt.text),
        updatedAt: DateTime.now(),
      );

      await produtoService.atualizarProduto(produto);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto atualizado com sucesso!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _descricaoController.dispose();
    _imagemUrlController.dispose();
    _categoriaController.dispose();
    _estoqueController.dispose();
    _fornecedorController.dispose();
    _pesoController.dispose();
    _createdAt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Produto')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_errorMessage!),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Voltar'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Produto *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _precoController,
                      decoration: const InputDecoration(
                        labelText: 'Preço (R\$) *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Número inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descricaoController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _imagemUrlController,
                      decoration: const InputDecoration(
                        labelText: 'URL da Imagem',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _categoriaController,
                      decoration: const InputDecoration(
                        labelText: 'Categoria *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _estoqueController,
                      decoration: const InputDecoration(
                        labelText: 'Estoque *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Número inteiro inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _fornecedorController,
                      decoration: const InputDecoration(
                        labelText: 'Fornecedor *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _pesoController,
                            decoration: const InputDecoration(
                              labelText: 'Peso',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _unidadeMedida,
                            decoration: const InputDecoration(
                              labelText: 'Unidade *',
                              border: OutlineInputBorder(),
                            ),
                            items: _unidades.map((unidade) {
                              return DropdownMenuItem(
                                value: unidade,
                                child: Text(unidade),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _unidadeMedida = value!;
                              });
                            },
                            validator: (value) =>
                                value == null ? 'Selecione uma unidade' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selecionarData(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Data de Validade',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                _dataValidade == null
                                    ? 'Selecionar data'
                                    : '${_dataValidade!.day}/${_dataValidade!.month}/${_dataValidade!.year}',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SwitchListTile(
                            title: const Text('Ativo'),
                            value: _isActive,
                            onChanged: (value) {
                              setState(() {
                                _isActive = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _isSaving
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _salvarProduto,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: const Text('Salvar Alterações'),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
