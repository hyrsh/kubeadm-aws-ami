# Caution

This ingress controller is a default NGINX with minimal setup configuration.

It will throw exactly one error due to a lack of permissions of the RBAC Account "default" in the "kube-system" namespace.
To fix this you have to set permissive RBAC setting to this account which I will not automate for you (you are responsible for your cluster).

# Hint

You "could" add the default Account to the cluster admins to give it all permissions and you can be sure that your cluster gets only accessed by you.
Not advisable in an "important" environment.
