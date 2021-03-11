import 'package:flutter/material.dart';

class OrganizationFooter extends StatelessWidget {
  final Function _addOrganizationFn;

  OrganizationFooter(this._addOrganizationFn);

  @override
  build(BuildContext context) {
    return Container(
      height: 45.0,
      width: double.infinity,
      child: ElevatedButton(
        child: Text(
          'Join Organization',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        onPressed: () => _addOrganizationFn(),
      ),
    );
  }
}
