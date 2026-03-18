//& Imports packages
import 'package:flutter/material.dart';
//& Imports models
import 'package:app_lojinha/models/product.dart';
//& Imports services
import 'package:app_lojinha/services/services/product_service.dart';

class UpdateProductPage extends StatefulWidget {
  final String productId;

  const UpdateProductPage({super.key, required this.productId});

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController();
  final _stockController = TextEditingController();
  final _supplierController = TextEditingController();
  final _weightController = TextEditingController();
  final _createdAt = TextEditingController();

  DateTime? _expiryDate;
  String _unitOfMeasure = 'un';
  bool _isActive = true;

  final List<String> _unit = ['un', 'kg', 'g', 'l', 'ml', 'cx'];

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  final productService = ProductService();

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  Future<void> _getProduct() async {
    try {
      final product = await productService.getProduct(widget.productId);
      if (product == null) {
        setState(() {
          _errorMessage = 'Produto não encontrado';
          _isLoading = false;
        });
        return;
      }

      _nameController.text = product.name;
      _priceController.text = product.price.toString();
      _descriptionController.text = product.description ?? '';
      _imageUrlController.text = product.imageUrl ?? '';
      _categoryController.text = product.category;
      _stockController.text = product.stock.toString();
      _supplierController.text = product.supplier;
      _weightController.text = product.weight?.toString() ?? '';
      _expiryDate = product.expiryDate;
      _unitOfMeasure = product.unitOfMeasure;
      _isActive = product.isActive;
      _createdAt.text = product.createdAt.toIso8601String();

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  Future<void> _salveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final product = Product(
        id: widget.productId,
        name: _nameController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        imageUrl: _imageUrlController.text.isEmpty
            ? null
            : _imageUrlController.text,
        category: _categoryController.text,
        stock: int.parse(_stockController.text),
        expiryDate: _expiryDate,
        supplier: _supplierController.text,
        weight: _weightController.text.isEmpty
            ? null
            : double.parse(_weightController.text),
        unitOfMeasure: _unitOfMeasure,
        isActive: _isActive,
        createdAt: _createdAt.text.isEmpty
            ? DateTime.now()
            : DateTime.parse(_createdAt.text),
        updatedAt: DateTime.now(),
      );

      await productService.updateProduct(product);

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
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    _stockController.dispose();
    _supplierController.dispose();
    _weightController.dispose();
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
                      controller: _nameController,
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
                      controller: _priceController,
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
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'URL da Imagem',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _categoryController,
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
                      controller: _stockController,
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
                      controller: _supplierController,
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
                            controller: _weightController,
                            decoration: const InputDecoration(
                              labelText: 'Peso (kg)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _unitOfMeasure,
                            decoration: const InputDecoration(
                              labelText: 'Unidade *',
                              border: OutlineInputBorder(),
                            ),
                            items: _unit.map((unidade) {
                              return DropdownMenuItem(
                                value: unidade,
                                child: Text(unidade),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _unitOfMeasure = value!;
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
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Data de Validade',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                _expiryDate == null
                                    ? 'Selecionar data'
                                    : '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}',
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
                            onPressed: _salveProduct,
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
