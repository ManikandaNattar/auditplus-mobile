import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './organization_item.dart';
import './../../../models/organization.dart';
import './organization_footer.dart';
import './organization_form.dart';
import './organization_loader.dart';
import '../../shared/show_data_empty_image.dart';

class OrganizationBody extends StatefulWidget {
  @override
  _OrganizationBodyState createState() => _OrganizationBodyState();
}

class _OrganizationBodyState extends State<OrganizationBody> {
  List<Organization> _organizations = [];

  void _deleteOrganization(String name) {
    setState(() {
      SharedPreferences.getInstance().then((prefs) {
        List<String> orgs = prefs.getStringList('organizations');
        if (orgs == null) {
          orgs = [];
        }
        orgs.removeWhere((org) => org == name);
        prefs.setStringList('organizations', orgs);
        _organizations.removeWhere((elm) => elm.name == name);
      });
    });
  }

  void _addOrganization() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      isScrollControlled: true,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'Join Organization',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 0.0,
                ),
                child: OrganizationForm(),
              ),
            ],
          ),
        );
      },
    ).then(
      (dynamic result) {
        if (result != null) {
          String organizationName = result['name'];
          SharedPreferences.getInstance().then(
            (prefs) {
              List<String> organizations = prefs.getStringList('organizations');
              if (organizations == null) {
                organizations = [];
              }
              organizations.removeWhere((elm) => elm == organizationName);
              organizations.add(organizationName);
              prefs.setStringList('organizations', organizations);
              setState(() {
                _organizations.add(Organization(organizationName));
              });
            },
          );
        }
      },
    );
  }

  Future<void> _getOrganizations() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> orgs = prefs.getStringList('organizations');
    if (orgs != null) {
      _organizations = orgs.map((name) => Organization(name)).toList();
    } else {
      _organizations = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            child: FutureBuilder(
              future: _getOrganizations(),
              builder: (_, authResultSnapshot) =>
                  authResultSnapshot.connectionState == ConnectionState.waiting
                      ? OrganizationLoader()
                      : _organizations.isEmpty
                          ? ShowDataEmptyImage()
                          : ListView(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              children: [
                                ..._organizations
                                    .map(
                                      (Organization elm) => OrganizationItem(
                                          elm, _deleteOrganization),
                                    )
                                    .toList(),
                              ],
                            ),
            ),
          ),
        ),
        OrganizationFooter(_addOrganization),
      ],
    );
  }
}
