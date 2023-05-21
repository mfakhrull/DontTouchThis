import 'package:flutter/material.dart';
import 'package:shoe_brand/common_widgets/shoe_builder.dart';
import 'package:shoe_brand/common_widgets/brand_builder.dart';
import 'package:shoe_brand/models/brand.dart';
import 'package:shoe_brand/models/shoe.dart';
import 'package:shoe_brand/pages/brand_form_page.dart';
import 'package:shoe_brand/pages/shoe_form_page.dart';
import 'package:shoe_brand/services/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Shoe>> _getShoes() async {
    return await _databaseService.shoes();
  }

  Future<List<Brand>> _getBrands() async {
    return await _databaseService.brands();
  }

  Future<void> _onShoeDelete(Shoe shoe) async {
    await _databaseService.deleteShoe(shoe.id!);
    setState(() {});
  }

  Future<void> _onBrandDelete(Brand brand) async {
    await _databaseService.deleteBrand(brand.id!);
    setState(() {});
  }

  void _onShoeEdit(Shoe shoe) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => ShoeFormPage(shoe: shoe),
            fullscreenDialog: true,
          ),
        )
        .then((_) => setState(() {}));
  }

  void _onBrandEdit(Brand brand) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => BrandFormPage(brand: brand),
            fullscreenDialog: true,
          ),
        )
        .then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shoe Database'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Shoes'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Brands'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ShoeBuilder(
              future: _getShoes(),
              onEdit: _onShoeEdit,
              onDelete: _onShoeDelete,
            ),
            BrandBuilder(
              future: _getBrands(),
              onEdit: _onBrandEdit,
              onDelete: _onBrandDelete,
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => const BrandFormPage(
                          brand: null,
                        ),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((_) => setState(() {}));
              },
              heroTag: 'addBrand',
              child: const FaIcon(FontAwesomeIcons.plus),
            ),
            const SizedBox(height: 12.0),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => const ShoeFormPage(),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((_) => setState(() {}));
              },
              heroTag: 'addShoe',
              child: const FaIcon(FontAwesomeIcons.bagShopping),
            ),
          ],
        ),
      ),
    );
  }
}
