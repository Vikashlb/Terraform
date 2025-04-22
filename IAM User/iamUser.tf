resource "aws_iam_user" "Kriesh_User" {
  name = "Kriesh"
}

resource "aws_iam_user_login_profile" "Kriesh_Login_Profile" {
  user = aws_iam_user.Kriesh_User.name
}

output "password" {
  value = aws_iam_user_login_profile.Kriesh_Login_Profile.password
  sensitive = true
}

resource "aws_iam_user_policy" "s3_list_only_policy" {
  name = "S3ListOnlyPolicy"
  user = aws_iam_user.Kriesh_User.name

  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [{
   "Effect": "Allow",
   "Action": [
     "s3:ListAllMyBuckets"
   ],
   "Resource": "*"
 }]
}
 EOF
}