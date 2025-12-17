import 'package:flutter/material.dart';
import 'package:untitled/Pages/addtocart.dart';
import 'package:velocity_x/velocity_x.dart';

import '../dialog.dart';
import 'CatalogImage.dart';

class CatalogList extends StatelessWidget {
  const CatalogList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: CatalogModel.items.length,
      itemBuilder: (context, index) {
        final catalog = CatalogModel.items[index];
        return CatalogItem(
          catalog: catalog,
        );
      },
    );
  }
}

class CatalogItem extends StatelessWidget {
  final Item catalog;

  CatalogItem({Key? key, required this.catalog}) : super(key: key);

  final ButtonStyle customButtonStyle = ElevatedButton.styleFrom(
    shape: const StadiumBorder(),
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;
    final itemHeight = isSmallScreen ? 120.0 : (isMediumScreen ? 130.0 : 150.0);
    final padding = isSmallScreen ? 6.0 : (isMediumScreen ? 8.0 : 10.0);
    
    return Padding(
      padding: EdgeInsets.all(padding),
      child: VxBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CatalogImage(image: catalog.image),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isSmallScreen ? 4 : 8, 
                  isSmallScreen ? 4 : 8, 
                  isSmallScreen ? 4 : 8, 
                  isSmallScreen ? 4 : 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            catalog.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : (isMediumScreen ? 16 : 18),
                              color: context.accentColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: isSmallScreen ? 2 : 4),
                          Text(
                            catalog.desc,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 11 : (isMediumScreen ? 12 : 14),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "₹${catalog.price}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 16 : (isMediumScreen ? 18 : 20),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AddToCart(catalog: catalog),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ).color(context.cardColor).rounded.height(itemHeight).make(),
    );
  }
}
