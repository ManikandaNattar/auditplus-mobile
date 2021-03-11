import 'package:flutter/material.dart';
import './../../../models/organization.dart';

class OrganizationItem extends StatelessWidget {
  final Organization _organization;
  final Function _deleteOrganizationFn;

  OrganizationItem(this._organization, this._deleteOrganizationFn);

  void routeToLogin(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/login',
      arguments: {'organization': _organization.name},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 5.0,
      ),
      child: GestureDetector(
        onTap: () => routeToLogin(context),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                child: Text(
                  _organization.avatar,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
            radius: 25.0,
          ),
          title: Text(
            _organization.name,
            style: Theme.of(context).textTheme.headline1,
          ),
          subtitle: Text(
            _organization.domain,
            style: Theme.of(context).textTheme.headline3,
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () => _deleteOrganizationFn(_organization.name),
          ),
        ),
      ),
    );
  }
}
