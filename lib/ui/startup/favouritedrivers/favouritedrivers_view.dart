import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:avenride/ui/startup/favouritedrivers/favouritedrivers_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FavouriteDriversView extends StatelessWidget {
  const FavouriteDriversView({Key? key, required this.favourite})
      : super(key: key);
  final List favourite;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FavouriteDriversViewModel>.reactive(
      onModelReady: (model) {
        print(favourite);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Favourites'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                verticalSpaceRegular,
                FavouriteDriver(
                  image:
                      'https://i.pinimg.com/originals/15/7f/c8/157fc80c7094081c6da691871fa1e196.jpg',
                  isOnline: true,
                  mobileno: '4353454355',
                  name: 'Nick Jonas',
                  ridecompleted: '234',
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => FavouriteDriversViewModel(),
    );
  }
}

class FavouriteDriver extends StatelessWidget {
  const FavouriteDriver({
    Key? key,
    required this.image,
    required this.isOnline,
    required this.mobileno,
    required this.name,
    required this.ridecompleted,
  }) : super(key: key);
  final String image;
  final String name;
  final String mobileno;
  final String ridecompleted;
  final bool isOnline;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(image),
                  radius: 50,
                ),
                horizontalSpaceSmall,
                SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mob no: $mobileno',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          verticalSpaceTiny,
                          Text(
                            '$ridecompleted rides completed',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: isOnline ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
