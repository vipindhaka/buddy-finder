import 'package:flutter/material.dart';

class RadiusSelector extends StatefulWidget {
  final Function sendRadius;
  final radius;
  RadiusSelector(this.radius, this.sendRadius);
  @override
  _RadiusSelectorState createState() => _RadiusSelectorState(radius);
}

class _RadiusSelectorState extends State<RadiusSelector> {
  double radius;
  _RadiusSelectorState(this.radius);

  @override
  Widget build(BuildContext context) {
    //print(radius);
    widget.sendRadius(radius);
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Maximum Radius',
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              width: size.width * .45,
            ),
            Text(
              radius.toInt().toString() + ' km',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: size.width * .95,
          child: Slider(
            //divisions: 10,
            //label: 'Radius',
            min: 5.0,
            max: 1000.0,
            value: radius,
            onChanged: (newradius) {
              setState(() {
                radius = newradius;
                widget.sendRadius(newradius);
                //print(newradius);
              });
            },
          ),
        )
      ],
    );
  }
}
