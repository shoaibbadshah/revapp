import 'package:avenride/api/firestore_api.dart';
import 'package:avenride/app/app.locator.dart';
import 'package:avenride/models/application_models.dart';
import 'package:avenride/services/user_service.dart';
import 'package:avenride/ui/paymentui/creditcard_view.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:avenride/ui/shared/ui_helpers.dart';

class CreditCardList extends StatefulWidget {
  const CreditCardList({Key? key}) : super(key: key);

  @override
  _CreditCardListState createState() => _CreditCardListState();
}

class _CreditCardListState extends State<CreditCardList> {
  final navigationService = locator<NavigationService>();
  final firestoreApi = locator<FirestoreApi>();
  final userService = locator<UserService>();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Users>>.value(
      value: firestoreApi.streamuser(userService.currentUser!.id),
      initialData: [
        Users(
          id: 'id',
          email: 'email',
          defaultAddress: 'defaultAddress',
          name: 'name',
          photourl:
              'https://img.icons8.com/color/48/000000/gender-neutral-user.png',
          personaldocs: 'personaldocs',
          bankdocs: 'bankdocs',
          vehicle: 'vehicle',
          isBoat: false,
          isVehicle: false,
          vehicledocs: 'vehicledocs',
          notification: [],
          mobileNo: '',
          cards: [],
          favourites: [],
        ),
      ],
      builder: (context, child) {
        var users = Provider.of<List<Users>>(context);
        if (users.length == 0) {
          return NotAvailable();
        }
        Users user = users.first;
        return Scaffold(
          appBar: AppBar(
            title: Text('Card List'),
          ),
          body: user.cards.length == 0
              ? Center(
                  child: Text('No cards Available'),
                )
              : ListView.builder(
                  itemCount: user.cards.length,
                  itemBuilder: (context, index) {
                    return CreditCardWidget(
                      cardNumber: user.cards[index]['number'],
                      expiryDate:
                          '${user.cards[index]['expiryMonth']}/${user.cards[index]['expiryYear']}',
                      isHolderNameVisible: false,
                      cardHolderName: 'cardHolderName',
                      cvvCode: user.cards[index]['cvc'],
                      showBackView: true,
                      isChipVisible: true,
                      onCreditCardWidgetChange:
                          (CreditCardBrand) {}, //true when you want to show cvv(back) view
                    );
                  },
                ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenWidth(context) / 2.4,
                  child: ElevatedButton(
                    onPressed: () {
                      navigationService.navigateToView(CreditCardView(
                        onSuccess: (data) {
                          saveCard(data, user.cards);
                        },
                      ));
                    },
                    child: Text('Add a Card'),
                  ),
                ),
                Visibility(
                  visible: user.cards.length == 0 ? false : true,
                  child: Container(
                    width: screenWidth(context) / 2.4,
                    child: ElevatedButton(
                      onPressed: () {
                        navigationService.back();
                      },
                      child: Text('Continue'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void saveCard(data, List cards) async {
    print(data);
    if (cards.contains(data['number'])) {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: new Text('Card Already Exist'),
        duration: Duration(seconds: 3),
        action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar(),
        ),
      ));
      return;
    } else {
      List cardData = [data];

      firestoreApi.updateRider(
        data: {
          "cards": cardData,
        },
        user: userService.currentUser!.id,
      );
    }
  }
}
