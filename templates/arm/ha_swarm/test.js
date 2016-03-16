var path = require('path');
var tl = require('vso-task-lib');
var fs = require("fs");
var common = require("azure-common");
var resourceManagement = require("azure-arm-resource");

var resourceGroupName = 'temp';
var deploymentName = 'deploymentName';
var templatePath = 'path';
var parameters = 'path';
var subscriptionId = '';
var token = 'dxjo3gemxmcayb6csg3k7ibhof6kwfyw3i6un3irjlefvxtywyrq'

var resourceManagementClient = resourceManagement.createResourceManagementClient(new common.TokenCloudCredentials({
  subscriptionId: subscriptionId,
  token: token
}));
var params = {
    templateLink: templatePath
};
if(parameters){
    params.parameters = parameters;
}

var res = resourceManagementClient.createOrUpdate(resourceGroupName, deploymentName, params, function (err){
    if(err){
        tl.error(err);
        tl.exit(1);
    }
});