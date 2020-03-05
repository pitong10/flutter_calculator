import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple calculator",
    home: MainForm(),
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.lightGreen,
      accentColor: Colors.lightGreenAccent,
    ),
  ));
}

class MainForm extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MainFormState();
  }
}

class _MainFormState extends State<MainForm> {

  var _formKey = GlobalKey<FormState>();

  var _currencies = ['IDR', 'USD', 'EUR'];
  var selectedCurr = '';
  var displayResult = '';
  final _minimumPadding = 5.0;
  TextEditingController principalController = new TextEditingController();
  TextEditingController rateController = new TextEditingController();
  TextEditingController termController = new TextEditingController();

  @override
  void initState() {
    selectedCurr = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(_minimumPadding * 2),
          child: ListView(
            children: <Widget>[
              getImageAsset(),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    validator: (String value) {
                      final numbers = num.tryParse(value);
                      if(value.isEmpty){
                        return 'Please fill principal field';
                      }else
                        return null;
                    },
                    inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Principal',
                      hintText: 'Enter principal, e.g 1200',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 15.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_minimumPadding),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    controller: principalController,
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    validator: (String value) {
                      final numbers = num.tryParse(value);
                      if(value.isEmpty){
                        return 'Please fill RoI field';
                      }else
                        return null;
                    },
                    inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Rate of Interest',
                      labelStyle: textStyle,
                      hintText: 'In percent',
                      errorStyle: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 15.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_minimumPadding),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    controller: rateController,
                  )),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(right: _minimumPadding),
                        child: TextFormField(
                          validator: (String value) {
                            final numbers = num.tryParse(value);
                            if(value.isEmpty){
                              return 'Please fill term field';
                            }else
                              return null;
                          },
                          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            labelText: 'Term',
                            labelStyle: textStyle,
                            errorStyle: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 15.0,
                            ),
                            hintText: 'Time in years',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(_minimumPadding),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          style: textStyle,
                          controller: termController,
                        )),
                  ),
                  Container(
                    width: _minimumPadding * 5,
                  ),
                  Expanded(
                      child: DropdownButton<String>(
                    items: _currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (String itemSelected) {
                      _onDropDownSelected(itemSelected);
                    },
                    value: selectedCurr,
                  )),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: _minimumPadding, top: _minimumPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColorDark,
                        child: Text(
                          "Calculate",
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            if(_formKey.currentState.validate())
                              this.displayResult = _calculateTotalReturn();
                          });
                        },
                      ),
                    ),
                    Container(
                      width: _minimumPadding,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          "Reset",
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          resetAllValues();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: _minimumPadding),
                child: Text(
                  this.displayResult,
                  style: textStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage imageAsset = AssetImage('images/calculator.png');
    Image image = Image(
      image: imageAsset,
      width: 125.0,
      height: 125.0,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 5),
    );
  }

  void _onDropDownSelected(String itemSelected) {
    setState(() {
      this.selectedCurr = itemSelected;
    });
  }

  String _calculateTotalReturn() {
    double principal = double.parse(principalController.text);
    double rate = double.parse(rateController.text);
    double term = double.parse(termController.text);

    double totalReturn = principal + (principal * rate * term) / 100;

    String result =
        'After $term years, your invesment will be worth $selectedCurr $totalReturn';
    return result;
  }

  void resetAllValues() {
    setState(() {
      principalController.text = '';
      rateController.text = '';
      termController.text = '';
      displayResult = '';
      selectedCurr = _currencies[0];
    });
  }
}
